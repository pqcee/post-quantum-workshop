# Post-quantum SSH Demo

This workshop demonstrates the use of a post-quantum key exchange
algorithm to simulate SSH communication between two Linux servers.
The hybrid post-quantum cipher `mlkem768x25519-sha256` is used to
secure their communication.

## Prerequisites

You should run the workshop on a Ubuntu 22.04 LTS (or later)
machine. You will use our pre-compiled `ssh` and `openssl`
libraries - the workshop instructions will also guide you through
the installation.

## Try the workshop

See [lab-post-quantum-ssh.md](lab-post-quantum-ssh.md).

## Workshop Previews

### Post-quantum key exchange in SSH

```diff
user@localmachine:~/dropbox$ scp -vi ~/.ssh/client-ecdsa-p384-key \
  -P 2222 \
+  -o KexAlgorithms=mlkem768x25519-sha256 \
  -o HostKeyAlgorithms=ecdsa-sha2-nistp384 \
  -o PubkeyAcceptedKeyTypes=ecdsa-sha2-nistp384 \
  -o PasswordAuthentication=no \
  ./package.txt ${USER}@localhost:~/dropbox
Executing: program /opt/pqcee/openssh/bin/ssh host localhost, user (unspecified), command sftp
debug1: OpenSSH_10.0p2, OpenSSL 3.5.2 5 Aug 2025
debug1: Reading configuration data /opt/pqcee/openssh/etc/ssh_config
debug1: Authenticator provider $SSH_SK_PROVIDER did not resolve; disabling
debug1: Connecting to localhost [::1] port 2222.
debug1: Connection established.
debug1: identity file /home/user/.ssh/client-ecdsa-p384-key type 2
debug1: identity file /home/user/.ssh/client-ecdsa-p384-key-cert type -1
debug1: Local version string SSH-2.0-OpenSSH_10.0
debug1: Remote protocol version 2.0, remote software version OpenSSH_10.0
debug1: compat_banner: match: OpenSSH_10.0 pat OpenSSH* compat 0x04000000
debug1: Authenticating to localhost:2222 as 'user'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
+ debug1: kex: algorithm: mlkem768x25519-sha256
debug1: kex: host key algorithm: ecdsa-sha2-nistp384
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: SSH2_MSG_KEX_ECDH_REPLY received
debug1: Server host key: ecdsa-sha2-nistp384 SHA256:RcrsLqkh5x8cBekViAbTkuboMMnp2rTYIdhi92ZOGhU
debug1: load_hostkeys: fopen /home/user/.ssh/known_hosts2: No such file or directory
debug1: load_hostkeys: fopen /opt/pqcee/openssh/etc/ssh_known_hosts: No such file or directory
debug1: load_hostkeys: fopen /opt/pqcee/openssh/etc/ssh_known_hosts2: No such file or directory
debug1: Host '[localhost]:2222' is known and matches the ECDSA host key.
debug1: Found key in /home/user/.ssh/known_hosts:1
debug1: ssh_packet_send2_wrapped: resetting send seqnr 3
debug1: rekey out after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: Sending SSH2_MSG_EXT_INFO
debug1: expecting SSH2_MSG_NEWKEYS
debug1: ssh_packet_read_poll2: resetting read seqnr 3
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey in after 134217728 blocks
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_ext_info_client_parse: server-sig-algs=<ecdsa-sha2-nistp384>
debug1: kex_ext_info_check_ver: publickey-hostbound@openssh.com=<0>
debug1: kex_ext_info_check_ver: ping@openssh.com=<0>
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_ext_info_client_parse: server-sig-algs=<ecdsa-sha2-nistp384>
debug1: Authentications that can continue: publickey,password,keyboard-interactive
debug1: Next authentication method: publickey
debug1: Will attempt key: /home/user/.ssh/client-ecdsa-p384-key ECDSA SHA256:IvAoQQNRcg2pAlfNn4SyiysMlfiybM9NQZRjLPd2bUc explicit
debug1: Offering public key: /home/user/.ssh/client-ecdsa-p384-key ECDSA SHA256:IvAoQQNRcg2pAlfNn4SyiysMlfiybM9NQZRjLPd2bUc explicit
debug1: Server accepts key: /home/user/.ssh/client-ecdsa-p384-key ECDSA SHA256:IvAoQQNRcg2pAlfNn4SyiysMlfiybM9NQZRjLPd2bUc explicit
Authenticated to localhost ([::1]:2222) using "publickey".
debug1: channel 0: new session [client-session] (inactive timeout: 0)
debug1: Requesting no-more-sessions@openssh.com
debug1: Entering interactive session.
debug1: pledge: filesystem
debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
debug1: client_input_hostkeys: searching /home/user/.ssh/known_hosts for [localhost]:2222 / (none)
debug1: client_input_hostkeys: searching /home/user/.ssh/known_hosts2 for [localhost]:2222 / (none)
debug1: client_input_hostkeys: hostkeys file /home/user/.ssh/known_hosts2 does not exist
debug1: client_input_hostkeys: no new or deprecated keys from server
debug1: Remote: /home/user/.ssh/authorized_keys:1: key options: agent-forwarding port-forwarding pty user-rc x11-forwarding
debug1: Remote: /home/user/.ssh/authorized_keys:1: key options: agent-forwarding port-forwarding pty user-rc x11-forwarding
debug1: Sending subsystem: sftp
debug1: pledge: fork
package.txt                        100%   46    70.2KB/s   00:00
scp: debug1: truncating at 46
debug1: client_input_channel_req: channel 0 rtype exit-status reply 0
debug1: channel 0: free: client-session, nchannels 1
Transferred: sent 3528, received 3976 bytes, in 0.1 seconds
Bytes per second: sent 68728.4, received 77455.9
debug1: Exit status 0
```

### Quantum-secure connection as verified by [PacketQC](https://packetqc.pqcee.com)

<!-- markdownlint-disable-next-line MD001 MD033 -->
<img width="1677" height="950" alt="image" src="https://github.com/user-attachments/assets/544cd739-24bb-427b-99d7-235fa09174fe" />
