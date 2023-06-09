#!/bin/bash
set -e
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc

# Define the minimum required version for each script
declare -A required_versions=(
  ["menu-master.sh"]="0.0.2"
  ["menu-hacking.sh"]="0.0.2"
  ["menu-customize.sh"]="0.0.2"
  ["menu-apps.sh"]="0.0.2"
  ["menu-backup_pwn-script.sh"]="0.0.2"
  [".envrc"]="0.0.2"
  ["README.md"]="0.0.2"
  ["version-check.sh"]="0.0.2"
  ["version.sh"]="0.0.2"
  ["SETUP.sh"]="0.0.2"
  ["INSTALL.sh"]="0.0.2"
  ["INSTALL.zip"]="0.0.2"
  [".shellcheckrc"]="0.0.2"
  ["support/support-Banner_func.sh"]="0.0.2"
  ["support/support-fatrat.sh"]="0.0.2"
  ["support/support-fix-my-perm.sh"]="0.0.2"
  ["support/support-hxcdump.sh"]="0.0.2"
  ["support/support-linux_connection_script.sh"]="0.0.2"
  ["support/support-makeWordlist.sh"]="0.0.2"
  ["support/support-Prompt_func.sh"]="0.0.2"
  ["support/support-sysinfo.sh"]="0.0.2"
  ["support/support-trap-wifi.sh"]="0.0.2"
  ["support/support-webmin.sh"]="0.0.2"
  ["support/support-wifite.sh"]="0.0.2"
)

function check_version {
  script_path=$1
  script_name=$(basename "$script_path")
  current_version=$(grep '^# Version:' "$script_path" | awk '{print $3}')
  required_version=${required_versions[$script_name]}
  
  if [[ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" != "$required_version" ]]; then
    printf "${RED}Error: $script_path version $required_version or higher is required (current version is $current_version)" >&2
    exit 1
  fi
}

function update_script {
  script_name=$1
  script_path=$2
  latest_version=$(curl -s https://raw.githubusercontent.com/Beesoc/beesoc-menu/0.1/"$script_name" | grep '^# Version:' | awk '{print $3}')

  if [[ "$(printf '%s\n' "$latest_version" "${required_versions[$script_name]}" | sort -V | head -n1)" == "$latest_version" ]]; then
    echo "Updating $script_name to version $latest_version"
    curl -s https://raw.githubusercontent.com/your_github_username/your_repo_name/main/"$script_name" > "$script_path"
    chmod +x "$script_path"
  fi
}

for script_path in $(find . -type f -name "*.sh"); do
  check_version "$script_path"
done

for script_path in $(find . -type f -name "*.sh"); do
  script_name=$(basename "$script_path")
  update_script "$script_name" "$script_path"
done

echo "All scripts are up to date."
