# Lab on post quantum SSH (pqSSH)

This lab activity will guide you to set up a quantum-safe SSH connection on a
localhost system. You should run this lab activity on Ubuntu 22.04 LTS or later.

## Install pqSSH

Please follow the instructions below to install pqSSH on your Linux system.

1. Log in to your WSL Ubuntu 22.04.

1. Clone the GitHub repository to your home directory.

   ```bash
   cd ~
   git clone https://github.com/pqcee/post-quantum-workshop.git
   ```

1. Download `pqSSH_0.6.5_Ubuntu_2204_LTS_x64.tar.gz`, in the
   [Release section](https://github.com/pqcee/post-quantum-workshop/releases) of
   the repository, to your current directory.

1. Install pqSSH using the provided script.

   ```bash
   ./install_pqSSH.sh
   source ~/.bashrc
   ```

1. Verify that you have correctly installed pqSSH.

   Check ssh client version with `ssh -V` and you should see the following

   ```text
   OpenSSH_10.3p1, OpenSSL 3.5.6 7 Apr 2026
   ```

   Check sshd server version with `/opt/pqcee/openssh/sbin/sshd -V` and you
   should see the same version being reported

   ```text
   OpenSSH_10.3p1, OpenSSL 3.5.6 7 Apr 2026
   ```

### Check Support for Quantum-safe Cipher(s)

Having installed pqSSH, we can check what quantum-safe cipher is supported

```bash
ssh -Q kex | grep mlkem
```

You should see the hybrid post-quantum cipher `mlkem768x25519-sha256`.

> [!NOTE]
> The newest openSSH v10 does not support ML-DSA. You can check the list
> of supported signature algorithms with `ssh -Q sig`.

## Configure SSH Keys

We will configure both ssh client and sshd server to enforce the following
cryptographic algorithms.

- Key exchange: `mlkem768x25519-sha256`
- Signature algorithm: `ecdsa-sha2-nistp384`

Follow the steps below to generate the keys:

1. Generate SSH host key pair for `sshd`.

   ```bash
   cd /opt/pqcee/openssh/etc
   sudo /opt/pqcee/openssh/bin/ssh-keygen -t ecdsa-sha2-nistp384 -f ./ssh_host_ecdsa_p384_key -N ''
   sudo chown "$USER":"$USER" ssh_host_ecdsa_p384_key*
   ```

   Use `ll` to check that you have created a pair of public and private keys.

1. Derive the key fingerprint of the SSH host public key to check in a later
   "secure file transfer" step.

   ```bash
   ssh-keygen -lf ./ssh_host_ecdsa_p384_key.pub
   ```

   Jot down the value of the key fingerprint.

1. (Optional) If `~/.ssh` directory does not exist, create this directory with
   the appropriate permissions to contain SSH client keys.

   ```bash
   cd ~
   mkdir .ssh
   chmod 700 .ssh
   ```

1. Generate SSH client key pair for `ssh`.

   ```bash
   cd ~/.ssh
   /opt/pqcee/openssh/bin/ssh-keygen -t ecdsa-sha2-nistp384 -f ./client-ecdsa-p384-key -N ''
   ```

1. (Optional) If `authorized_keys` file does not exist in the `.ssh` directory,
   create this file with appropriate permissions to contain list of SSH client
   public keys authorised for incoming SSH connections.

   ```bash
   touch authorized_keys
   chmod 600 authorized_keys
   ```

1. Add SSH client public key to `authorized_keys` file.

   ```bash
   cat ./client-ecdsa-p384-key.pub >> ./authorized_keys
   ```

## Establish Quantum-Safe SSH Connection

Having created the SSH keys, we can now set up SSH server to receive SSH
connections.

### Environment Setup

We will need to open 3 separate console tabs in your Terminal app to deploy
SSH server, SSH client and to perform packet capture of the SSH connection.

1. In the 1st console tab, we will start `sshd` on port 2222.

   ```bash
   /opt/pqcee/openssh/sbin/sshd -D -o KexAlgorithms=mlkem768x25519-sha256 -o HostKeyAlgorithms=ecdsa-sha2-nistp384 -o PubkeyAcceptedKeyTypes=ecdsa-sha2-nistp384 -p 2222 -h /opt/pqcee/openssh/etc/ssh_host_ecdsa_p384_key
   ```

   **Note**: If you wish to stop `sshd`, press `Ctrl + C` in this console.

1. In the 2nd console tab, we will start `tcpdump` to capture SSH traffic for
   `PCAP` analysis later.

   ```bash
   sudo tcpdump -i lo port 2222 -w ssh_dump.pcap
   ```

   **Note**: If you wish to stop packet capture, press `Ctrl + C` in this
   console.

1. In the 3rd console tab, we will initiate SSH client connections from here to
   our localhost SSH server on port 2222. Please prepare your 3rd console as
   follows

   ```bash
   cd ~
   mkdir dropbox
   echo "This is to be sent to dropbox over SSH." > package.txt
   ```

### Secure Transfer a File over pqSSH

In the 3rd console tab,

1. Transfer `package.txt` to `dropbox` directory on SSH server.

   ```bash
   scp -i ~/.ssh/client-ecdsa-p384-key -P 2222 -o KexAlgorithms=mlkem768x25519-sha256 -o HostKeyAlgorithms=ecdsa-sha2-nistp384 -o PubkeyAcceptedKeyTypes=ecdsa-sha2-nistp384 -o PasswordAuthentication=no ./package.txt ${USER}@localhost:~/dropbox
   ```

1. (Optional) If you are prompted to accept ECDSA key fingerprint, verify that
   the key fingerprint value matches the value you jotted down earlier, and
   type `yes` and press `Enter` to proceed.

1. Your file will be successfully transferred and you should see the file
   appear in the `dropbox` directory.

   ```bash
   cd dropbox
   ll
   cat package.txt
   ```

### Verify the SSH connection is Quantum Safe

We want to verify that the SSH connection is indeed using a quantum-safe
cipher. We do this as follows

1. Stop packet capture for port 2222. Press `Ctrl + C` in the 2nd console tab.

1. Copy the `PCAP` file to your Windows `Downloads` folder. Change
   `<windows_username>` accordingly for your Windows system.

   ```bash
   cp ./ssh_dump.pcap /mnt/c/Users/<windows_username>/Downloads/
   ```

1. Open a web browser and go to [PacketQC](https://packetqc.pqcee.com/).

   1. Click "Choose File" button. Select `ssh_dump.pcap` file in your
      `Downloads` folder and click Open button.

   1. Click on "Generate Network Report" to process the `PCAP` file.

   1. Click "Security Report" tab. You will observe that the SSH protocol in the
      session is marked green colour, which indicates connection is
      quantum-safe.

   1. Click the drop-down arrow on the right-hand side of the SSH protocol
      session. You will be able to observe that `mlkem768x25519-sha256` was
      indeed used for the Key Exchange algorithm in the SSH connection.

1. Congratulations! You have successfully performed a quantum-safe SSH
   connection and audited that the SSH session is indeed quantum-safe.

## Post-lab Cleanup

If you wish to remove pqSSH from your system after the lab, you can do the
following

1. Remove the pqSSH directory.

   ```bash
   cd /opt
   sudo rm -rf pqcee
   ```

1. Remove the last `export PATH` line in `.bashrc`.

   ```bash
   cd ~
   vim .bashrc
   source .bashrc
   ```

1. Remove the temporarily created files and folders.

   ```bash
   rm package.txt
   rm -rf dropbox
   rm ssh_dump.pcap
   ```

1. Remove the SSH client key files and remove the last line added to
   `authorized_keys` file and `known_hosts` file.

   ```bash
   cd .ssh
   rm client-ecdsa-p384-key*
   vim authorized_keys
   vim known_hosts
   ```
