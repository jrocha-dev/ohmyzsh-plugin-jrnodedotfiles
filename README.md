# jrnodedotfiles

A zsh plugin to streamline the setup of configuration files for JavaScript and TypeScript projects, including
Vue, Angular, React, and Node.js.

## Features

- Generate a `.editorconfig` file based on the selected project type.
- Initialize and configure ESLint with a `.eslintrc.js` file.
- Create a `.stylelintrc.js` file with stylelint configurations.

## Installation

1. Clone this repository to your oh-my-zsh custom plugins directory:

   ```zsh
   git clone https://github.com/yourusername/jrnodedotfiles.git ~/.oh-my-zsh/custom/plugins/jrnodedotfiles
   ```

2. Add `jrnodedotfiles` to the plugins array in your `.zshrc` file:

   ```zsh
   plugins=(... jrnodedotfiles)
   ```

3. Reload your zsh configuration:

   ```zsh
   source ~/.zshrc
   ```

## Usage

### Generating dotfiles using the `create-dotfiles` command

The `create-dotfiles` function generates configuration files based on the selected project type. It receives
the local path to the project directory as an optional argument. If no path is provided, the current directory
is used. Then it prompts the user to select the project type and the configuration files to generate. The
choice is sent to functions that create the selected configuration files. These functions are:

- `create_editorconfig`: Generates a `.editorconfig` file for code formatting.
- `create_prettierrc`: Generates a `.prettierrc` file for code formatting.
- `create_stylelintrc`: Creates a `.stylelintrc.js` file for style linting.
- `create_eslintrc`: Initializes ESLint and generates a `.eslintrc.js` file for code linting.
- `create_browserlistrc`: Generates a `.browserslistrc` file for Babel and Autoprefixer.
- `create_babelrc`: Generates a `.babelrc` file for transpiling JavaScript and TypeScript into
  browser-compatible code.
- `create_webpack`: Generates a `webpack.config.js` for module bundling and transpiling.
- `create_gulp`: Generates a `gulpfile.js` for task automation.
- `create_vite`: Generates a `vite.config.js` file for Vue and React projects.
- `create_tsconfig`: Generates a `tsconfig.json` file for TypeScript projects.
- `create_docker-compose`: Generates a `docker-compose.yml` file to unify the development environment.
- `create_test_files`:
  - Configure Cypress for BDD and E2E, and Jest for TDD/Unit testing in React, Vue, and Angular projects;
  - React Testing Library for component testing in React projects;
  - Vue Test Utils for component testing in Vue projects;
  - Karma and Jasmine for TDD/Unit testing in Angular projects, and Angular Testing Library for component
    testing;
  - Mocha and Chai for TDD/Unit testing, BDD, and API testing in Node.js projects.

That way, the `create_editorconfig` function creates config files based on the selected project type.

```zsh
create-editorconfig [project_path]
```

- `project_path` (optional): The path to the project directory. Defaults to the current directory.

### Supported project types:

- Vue
- Vue with TypeScript
- Angular
- React
- React with TypeScript
- Node.js/API

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Feel free to contribute to this project by submitting issues and pull requests.
