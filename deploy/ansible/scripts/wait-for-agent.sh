STATUS=""
while [ "$STATUS" != "RUNNING" ] ; do
  STATUS=$(iofog-agent status | cut -f2 -d: | head -n 1 | tr -d '[:space:]')
  [ "$STATUS" != "RUNNING" ] && sleep 1
done
