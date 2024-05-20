# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.
# See: https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#overriding-and-adding-plugins

function choose_project_type {
  echo "Select project type:"
  echo "1) Vue"
  echo "2) Vue with TS"
  echo "3) Angular"
  echo "4) React"
  echo "5) React with TS"
  echo "6) Node/API"
  read -p "Enter number: " project_type
  echo "$project_type"
}

function msg_file_created { # $1 = project_path, $2 = project_type
  echo ".editorconfig created in $1 for $(
    case $2 in
    1) echo 'Vue' ;;
    2) echo 'Vue with TS' ;;
    3) echo 'Angular' ;;
    4) echo 'React' ;;
    5) echo 'React with TS' ;;
    6) echo 'Node/API' ;;
    esac
  ) project"
}

function create_dot_files {

  local project_path="${1:-.}" # Default to current directory

  create_editorconfig "$project_path"
  create_gitignore "$project_path"
  create_eslintrc "$project_path"
  create_prettierrc "$project_path"

}

function create_editorconfig {
  local project_path="${1:-.}"              # Default to current directory
  local project_type=$(choose_project_type) # Choose project type

  if [ -f "$project_path/.editorconfig" ]; then
    echo ".editorconfig already exists in $project_path"
    return
  fi

  # Create the basic structure of the .editorconfig file
  cat <<EOL >"$project_path/.editorconfig"
# .editorconfig for project
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
EOL

  case $project_type in
  # Vue with and without TS
  1 | 2)
    cat <<EOL >>"$project_path/.editorconfig"

[*.{js,ts,vue,css,scss}]
indent_style = space
indent_size = 2
EOL
    ;;
  # Angular
  3)
    cat <<EOL >>"$project_path/.editorconfig"

[*.{ts,html,css,scss}]
indent_style = space
indent_size = 2
EOL
    ;;
  # React with and without TS
  4 | 5)
    cat <<EOL >>"$project_path/.editorconfig"

[*.{js,jsx,ts,tsx,css,scss}]
indent_style = space
indent_size = 2
EOL
    ;;
  # Node/API
  6)
    cat <<EOL >>"$project_path/.editorconfig"

[*.{js,json}]
indent_style = space
indent_size = 2
EOL
    ;;
  *)
    echo "Invalid project type"
    rm "$project_path/.editorconfig"
    return
    ;;
  esac

  msg_file_created "$project_path" "$project_type"
}

create_stylelintrc() {
  local project_path="${1:-.}"              # Default to current directory
  local project_type=$(choose_project_type) # Choose project type

  if [ -f "$project_path/.stylelintrc.js" ]; then
    echo ".stylelintrc.js already exists in $project_path"
    return
  fi

  # Verify if packages for stylelint are instaled and install them if not
  if ! command -v stylelint &>/dev/null; then
    echo "stylelint is not installed. Installing..."
    npm install --save-dev stylelint stylelint-config-standard-scss stylelint-prettier
  fi

  cat <<EOL >"$project_path/.stylelintrc.js"
module.exports = {
  extends: [
    'stylelint-config-standard-scss',
    'stylelint-prettier',
  ],
  plugins: [
    'stylelint-scss',
    'stylelint-prettier',
  rules: {
    'prettier/prettier': true
  },
}
EOL

  msg_file_created "$project_path" "$project_type"
}

alias jr-cdf=create_dot_files
