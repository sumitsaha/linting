## Linting Setup

In order to lint and format your Next.js project automatically according to popular airbnb style guide, I recommend you to follow the instructions below.

### Install Dependency

```sh
npm i -g yarn
```

### Install Dev Dependencies

```sh
yarn add -D prettier
yarn add -D babel-eslint
npx install-peerdeps --dev eslint-config-airbnb
yarn add -D eslint-config-prettier eslint-plugin-prettier
```

### Setup Linting Configuration file manually (Next.js)

Create a `.eslintrc.json` file in the project root and enter the below contents:

```json
{
  "extends": [
    "airbnb",
    "airbnb/hooks",
    "eslint:recommended",
    "prettier",
    "prettier/react",
    "plugin:jsx-a11y/recommended"
  ],
  "parser": "babel-eslint",
  "parserOptions": {
    "ecmaVersion": 8
  },
  "env": {
    "browser": true,
    "node": true,
    "es6": true,
    "jest": true
  },
  "rules": {
    "react/react-in-jsx-scope": 0,
    "indent": 0,
    "linebreak-style": 0,
    "react-hooks/rules-of-hooks": "error",
    "no-console": 0,
    "react/state-in-constructor": 0,
    "react/prop-types": 0,
    "jsx-a11y/click-events-have-key-events": 0,
    "react/jsx-filename-extension": [
      1,
      {
        "extensions": [".js", ".jsx"]
      }
    ],
    "prettier/prettier": [
      "error",
      {
        "trailingComma": "es5",
        "singleQuote": true,
        "printWidth": 100,
        "tabWidth": 4,
        "semi": true
      }
    ]
  },
  "plugins": ["prettier", "react", "react-hooks"]
}
```

### Linting Shortcut Setup with bash script (JS, NextJs, NodeJs, ReactJs)

1. Windows users, make sure you have Git bash installed in your machine so that we can run bash scripts. Mac & Linux users do not need to install Git bash because it's already available there.

2. Windows users, edit this file '/C/Program Files/Git/etc/profile.d/aliases.sh'. Mac/Linux users need to edit this file '{$HOME}/.zshrc' file

3. If you want to add a shortcut for Next.js project linting with all the linting steps I described above, you can setup an alias in the above aliases.sh (windows) or .zshrc(Mac or Linux) file.

   ```sh
   alias lint-js="exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/sumitsaha/linting/master/js-eslint-prettier.sh 2> /dev/null)"
   ```
   ```sh
   alias lint-nextjs="exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/sumitsaha/linting/master/nextjs-eslint-prettier.sh 2> /dev/null)"
   ```
   ```sh
   alias lint-nodejs="exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/sumitsaha/linting/master/nodejs-eslint-prettier.sh 2> /dev/null)"
   ```
   ```sh
   alias lint-reactjs="exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/sumitsaha/linting/master/reactjs-eslint-prettier.sh 2> /dev/null)"
   ```

4. Now open your bash terminal and go to any project folder and then enter the below command

- JS
   ```sh
    lint-js
   ```
- Next.js
   ```sh
    lint-nextjs
   ```
- Node.js
   ```sh
    lint-nodejs
   ```
- React.js
   ```sh
    lint-reactjs
   ```

   This will pull necessary command from my repository and install into your machine accordingly. Enter 'y' to any prompt that you receive. You will see it will automatically do all the steps that I described into the above linting setup section.

<!-- EDITOR SETUP -->

## VS Code Editor Setup

In order to follow along the tutorial series, I recommend you to use Visual Studio Code Editor and install & apply the below extensions and settings.

### Extensions

Install the below extensions:

- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

### Settings

Go to your Visual Stuido Code `settings.json` file and add the below settings there:

```json
// config related to code formatting
"editor.defaultFormatter": "esbenp.prettier-vscode",
"editor.formatOnSave": true,
"[javascript]": {
"editor.formatOnSave": false
},
"prettier.disableLanguages": ["javascript"],
"editor.codeActionsOnSave": {
"source.fixAll.eslint": true,
"source.organizeImports": true
},
"eslint.alwaysShowStatus": true
```
