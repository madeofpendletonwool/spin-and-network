echo "Starting agent container"
docker-compose -f $1 up -d
echo "Applying ssh keys"
docker exec lynxx-agent bash -c "mkdir -p ~/.ssh"
docker exec lynxx-agent bash -c 'echo "$3" >> ~/.ssh/id_rsa'
docker exec lynxx-agent bash -c 'echo "$4" >> ~/.ssh/id_rsa.pub'
docker exec lynxx-agent bash -c "chmod 600 ~/.ssh/id_rsa"
docker exec lynxx-agent bash -c "chmod 644 ~/.ssh/id_rsa.pub"
echo "Joining tailnet"
docker exec lynxx-agent tailscaled --state=mem: &
sleep 3
docker exec lynxx-agent tailscale up --authkey=$2
docker exec lynxx-agent tailscale status