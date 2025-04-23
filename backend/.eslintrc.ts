module.exports = {
  // Use the TypeScript parser
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: 2021, // Allows for the parsing of modern ECMAScript features
    sourceType: "module", // Allows for the use of imports
    // Path to your tsconfig.json. This is required for rules that need type information.
    // Adjust the path if your tsconfig.json is not in the project root.
    project: "./tsconfig.json",
  },
  env: {
    node: true, // Enables Node.js global variables and environment
    es2021: true, // Adds all ECMAScript 2021 globals and enables parsing of ECMAScript 2021 features
  },
  // Extend from recommended rules, TypeScript, Node.js, and Prettier configurations
  extends: [
    "eslint:recommended", // Use the recommended ESLint rules
    "plugin:@typescript-eslint/recommended", // Use the recommended rules from @typescript-eslint
    "plugin:node/recommended", // Use the recommended rules from eslint-plugin-node
    "plugin:prettier/recommended", // Enables eslint-plugin-prettier and displays Prettier errors as ESLint errors. This must be the last configuration in the extends array.
  ],
  rules: {
    // Place any custom ESLint rules here.
    // You might want to override or disable some rules from the extended configurations.
    // Examples:
    // 'no-console': 'warn', // Warns about console.log statements
    // '@typescript-eslint/explicit-function-return-type': 'off', // Allows inferring return types
    // 'node/no-unpublished-import': 'off', // If you have issues with module resolution and monorepos
  },
};
