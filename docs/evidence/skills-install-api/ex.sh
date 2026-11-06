sed -n "/^UNPACK='/,/'\$/p" /home/user/Claude/templates/hooks/install-skills.sh | sed "1s/^UNPACK='//; \$s/'\$//" > unpack.py
