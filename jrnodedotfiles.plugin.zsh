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

  local project_path="${1:-.}"              # Default to current directory
  local project_type=$(choose_project_type) # Choose project type

  if [ -z "$project_type" ]; then
    echo "Invalid project type"
    return
  fi

  # Code formatting
  create_editorconfig "$project_path" "$project_type"
  create_prettierrc "$project_path" "$project_type"
  # Linting
  create_stylelintrc "$project_path" "$project_type"
  create_eslintrc "$project_path" "$project_type"

  # Browser compatibility
  create_browserlistrc "$project_path" "$project_type"
  create_babelrc "$project_path" "$project_type"
  create_postcssrc "$project_path" "$project_type"
  create_tsconfig "$project_path" "$project_type"

  # Build tools
  create_webpack "$project_path" "$project_type"
  create_vite "$project_path" "$project_type"

  # Automation
  create_gulp "$project_path" "$project_type"

  # Docker
  create_dockerfile "$project_path" "$project_type"
  create_docker-compose "$project_path" "$project_type"

  # Testing
  create_test_files "$project_path" "$project_type"
}

# ------------------------------------------------------------------------------

function create_editorconfig {
  local project_path="${1:-.}" # Default to current directory
  local project_type="${2}"    # Project type

  if [ -f "$project_path/.editorconfig" ]; then
    echo ".editorconfig already exists in $project_path"
    return
  fi

  # Common .editorconfig settings

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

  # Add file extensions based on project type

  if [ $project_type -eq 1 ] || [ $project_type -eq 2 ]; then
    echo [*.{js,ts,vue,css,scss}] >>"$project_path/.editorconfig"
  elif [ $project_type -eq 3 ]; then
    echo [*.{ts,component.html,css,scss}] >>"$project_path/.editorconfig" #
  elif [ $project_type -eq 4 ] || [ $project_type -eq 5 ]; then
    echo [*.{js,jsx,ts,tsx,css,scss}] >>"$project_path/.editorconfig"
  elif [ $project_type -eq 6 ]; then
    echo [*.{js,json}] >>"$project_path/.editorconfig"
  else
    echo "Invalid project type"
    rm "$project_path/.editorconfig"
    return
  fi

  # More common .editorconfig settings

  echo "indent_style = space" >>"$project_path/.editorconfig"
  echo "indent_size = 2" >>"$project_path/.editorconfig"

  # Inform user that file was created

  msg_file_created "$project_path" "$project_type"
}

# ------------------------------------------------------------------------------

function create_prettierrc {
  local project_path="${1:-.}" # Default to current directory
  local project_type="${2}"    # Project type

  if [ -f "$project_path/.prettierrc" ]; then
    echo ".prettierrc already exists in $project_path"
    return
  fi

  # create a .prettierrc file compatible with Airbnb style guide
  cat <<EOL >"$project_path/.prettierrc.js"
module.exports = {
  quoteProps: 'as-needed', // 3.6
  bracketSameLine: false, // 4.8*
  jsxBracketSameLine: false, // 4.8*
  singleQuote: true, // 6.1
  trailingComma: 'all', // 7.15
  arrowParens: 'always', // 8.4
  tabWidth: 2, // 19.1
  useTabs: false, // 19.1
  bracketSpacing: true, // 19.12
  printWidth: 100, // 19.13
  semi: true, // 21.1
  
  vueIndentScriptAndStyle: true,
  singleAttributePerLine: true,
  htmlWhitespaceSensitivity: 'css',
  endOfLine: 'lf',
}
EOL

  msg_file_created "$project_path" "$project_type"
}

# ------------------------------------------------------------------------------

function create_stylelintrc {
  local project_path="${1:-.}" # Default to current directory
  local project_type="${2}"    # Project type

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
  ],
  rules: {
    'prettier/prettier': true,
  },
}
EOL

  msg_file_created "$project_path" "$project_type"
}

# ------------------------------------------------------------------------------

function create_eslintrc {
  local project_path="${1:-.}" # Default to current directory
  local project_type="${2}"    # Project type

  # if eslint is not a dev dependency or file is not present, initialize eslint configuration

  if ! npm list eslint --depth=0 | grep -q 'eslint' || [ ! -f "$project_path/.eslintrc.config.js" ]; then
    echo "ESLint is not configured. Initializing ESLint configuration..."
    npm init @eslint/config@latest
  fi

  msg_file_created "$project_path" "$project_type"

}

# ------------------------------------------------------------------------------

function create_browserlistrc {
  local project_path="${1:-.}" # Default to current directory
  local project_type="${2}"    # Project type

  if [ -f "$project_path/.browserlistrc" ]; then
    echo ".browserlistrc already exists in $project_path"
    return
  fi

  if [ $project_type -eq 6 ]; then
    echo "Node/API project does not require .browserlistrc"
    return
  fi

  cat <<EOL >"$project_path/.browserlistrc"
# Browserslist configuration
fully supports webp and fully supports flexbox-gap
EOL

  msg_file_created "$project_path" "$project_type"

}

# ------------------------------------------------------------------------------

function create_babelrc {
  local project_path="${1:-.}" # Default to current directory
  local project_type="${2}"    # Project type

  if [ -f "$project_path/.babel.config.js" ]; then
    echo ".babel.config.js already exists in $project_path"
    return
  fi

  if [ $project_type -eq 6 ]; then
    echo "Node/API project does not require .babel.config.js"
    return
  fi

  # Initialize .babel.config.js with the base presets and plugins
  cat <<EOL >"$project_path/.babel.config.js"
module.exports = {
  presets: ['@babel/preset-env'$(
    case $project_type in
    1) echo ", '@vue/babel-preset-app'" ;;
    2) echo ", '@vue/babel-preset-app', '@babel/preset-typescript'" ;;
    4) echo ", '@babel/preset-react'" ;;
    5) echo ", '@babel/preset-react', '@babel/preset-typescript'" ;;
    esac
  )],
  plugins: ['@babel/plugin-transform-runtime'$(
    case $project_type in
    3) echo ", '@babel/plugin-proposal-decorators', '@babel/plugin-proposal-class-properties'" ;;
    esac
  )]
};
EOL

  msg_file_created "$project_path" "$project_type"

}

# ------------------------------------------------------------------------------

function create_postcssrc {
  local project_path="${1:-.}" # Default to current directory
  local project_type="${2}"    # Project type

  if [ -f "$project_path/postcss.config.js" ]; then
    echo "postcss.config.js already exists in $project_path"
    return
  fi

  if [ $project_type -eq 6 ]; then
    echo "Node/API project does not require postcss.config.js"
    return
  fi

  cat <<EOL >"$project_path/postcss.config.js"
module.exports = {
  plugins: [
    require('autoprefixer'),
    require('postcss-nested'),
    require('postcss-import'),
    require('postcss-preset-env')({
      stage: 1,
      features: {
        'nesting-rules': true, 
      },
    }),
    require('postcss-flexbugs-fixes'),
    require('postcss-normalize'),
    require('postcss-sorting'),
    require('cssnano'),
    require('stylelint'),
    require('postcss-color-function'),
    require('postcss-custom-properties')
    require('postcss-moodules'),
    // Additional plugins for CSS-in-JS
    require('postcss-html'),
    require('postcss-jsx'),
    require('postcss-js'),
    // Add SCSS/SASS support for all projects
    require('postcss-scss'),
    require('postcss-sass'),
  ],
};

EOL

  msg_file_created "$project_path" "$project_type"

}

# ------------------------------------------------------------------------------

function create_tsconfig {

  local project_path="${1:-.}" # Default to current directory
  local project_type="${2}"    # Project type

  if [ -f "$project_path/tsconfig.json" ]; then
    echo "tsconfig.json already exists in $project_path"
    return
  fi

  if [ $project_type -eq 1 ] || [ $project_type -eq 4 ]; then
    echo "Vue and React projects do not require tsconfig.json"
    return
  fi

  # Initialize tsconfig.json with the base configuration
  cat <<EOL >"$project_path/tsconfig.json"
{
  "compilerOptions": {
    "target": "esnext",
    "module": "esnext",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "sourceMap": true,
EOL

  # Add specific configurations based on project type
  case $project_type in
  1)
    # Vue with TypeScript
    cat <<EOL >>"$project_path/tsconfig.json"
    "jsx": "preserve",
    "lib": ["esnext", "dom"],
    "types": ["vite/client"]
  },
  "include": ["src/**/*.ts", "src/**/*.d.ts", "src/**/*.vue"],
  "exclude": ["node_modules"],
  "vueCompilerOptions": {
    "target": 3.2
  }
}
EOL
    ;;
  2)
    # Angular with TypeScript
    cat <<EOL >>"$project_path/tsconfig.json"
    "lib": ["es2018", "dom"],
    "types": ["node"]
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules"],
  "angularCompilerOptions": {
    "enableIvy": true,
    "fullTemplateTypeCheck": true,
    "strictInjectionParameters": true,
    "strictTemplates": true,
    "strictInputAccessModifiers": true,
    "strictOutputEventTypes": true,
    "strictDomEventTypes": true,
  }
}
EOL
    ;;
  3)
    # React with TypeScript
    cat <<EOL >>"$project_path/tsconfig.json"
    "jsx": "react-jsx",
    "lib": ["dom", "dom.iterable", "esnext"],
    "types": ["node", "jest"]
  }
  "include": ["src"],
  "exclude": ["node_modules"]
}
EOL
    ;;
  esac

  msg_file_created "$project_path" "$project_type"
}

# ------------------------------------------------------------------------------

alias jr-cdf=create_dot_files
