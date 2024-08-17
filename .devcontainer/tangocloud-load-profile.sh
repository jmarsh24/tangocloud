# this file is intended to be copied into /etc/profile.d

project_profile="/workspace/.devcontainer/profile.sh"
if [ -r $project_profile ]; then
  source $project_profile
else
  echo "File not found or not readable: $project_profile"
fi
