#!/bin/bash



ENVIRONMENT=$1
IMAGE_TAG=$2

# Set environment variables (adjust with your actual image tags)
export BACKEND_IMAGE_TAG=714714593268.dkr.ecr.us-east-1.amazonaws.com/backend:latest
export FRONTEND_IMAGE_TAG=${IMAGE_TAG}

# shellcheck disable=SC2296
echo "${{ secrets.SSH_PRIVATE_KEY }}" | tr -d '\r' > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

if [ "$ENVIRONMENT" = "staging" ]; then
  echo "Deploying to staging environment..."
  scp -i ~/.ssh/id_rsa docker-compose.yml ec2-user@<staging-ec2-instance-public-dns>:/home/ec2-user/docker-compose.yml
  ssh ~/.ssh/id_rsa ec2-user@<staging-ec2-instance-public-dns> 'cd /home/ec2-user && docker-compose up -d'
elif [ "$ENVIRONMENT" = "production" ]; then
  echo "Deploying to production environment..."
  scp -i ~/.ssh/id_rsa docker-compose.yml ec2-user@<production-ec2-instance-public-dns>:/home/ec2-user/docker-compose.yml
  ssh ~/.ssh/id_rsa ec2-user@<production-ec2-instance-public-dns> 'cd /home/ec2-user && docker-compose up -d'
elif [ "$ENVIRONMENT" = "development" ]; then
  echo "Deploying to development environment..."
  scp -i ~/.ssh/id_rsa docker-compose.yml ec2-user@<development-ec2-instance-public-dns>:/home/ec2-user/docker-compose.yml
  ssh ~/.ssh/id_rsa ec2-user@<development-ec2-instance-public-dns> 'cd /home/ec2-user && docker-compose up -d'
else
  echo "Unknown environment: $ENVIRONMENT"
  exit 1
fi

# Clean up - remove the SSH key file
rm -f ~/.ssh/id_rsa