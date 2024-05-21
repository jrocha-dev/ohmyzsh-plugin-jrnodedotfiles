# jrnodedotfiles

A zsh plugin to streamline the setup of configuration files for various JavaScript and TypeScript projects,
including Vue, Angular, React, and Node.js.

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

### Generating a .editorconfig File

The `create_editorconfig` function creates a `.editorconfig` file based on the selected project type.

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
