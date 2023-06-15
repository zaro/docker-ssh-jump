#!/bin/bash
if [ -z "$USER" ]; then
USER=jump
fi
for i in $(echo $USER | sed "s/,/ /g")
  do
    echo "INFO: Creating user $i";
    adduser -D -s /bin/bash $i;
    mkdir /home/$i/.ssh
    chmod 700 /home/$i/.ssh
    if [ "$(ls /keys/* 2>/dev/null)" ]; then
      echo "Adding keys from /keys/"
      cat /keys/* >> /home/$i/.ssh/authorized_keys
    fi
    for n in {0..9}
      do
        v="AUTH_KEY_${n}"
        if [ "${!v}" ]; then
          echo "Adding key from ${v}"
          echo "${!v}" >> /home/$i/.ssh/authorized_keys
        fi
      done
    chown -R $i: /home/$i/.ssh
    chmod 700 /home/$i/.ssh/authorized_keys

    if [ ! -f "/home/$i/.ssh/authorized_keys" ]
      then
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "No authorized_keys defined for user ${i}"
        echo "You will not be able to login as this user!"
        echo "To fix this either:"
        echo " - mount a directory with public keys under /keys/"
        echo " - set 1 or more environment variables containing public keys named AUTH_KEY_{0..9}"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      fi
done

ssh-keygen -A
exec /usr/sbin/sshd.pam -D -e
