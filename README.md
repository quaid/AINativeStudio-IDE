# AINative

<div align="center">
  <h1>AINative</h1>
  <p>AI-Native Development Environment</p>
</div>

AINative is a powerful, open-source development environment with built-in AI capabilities, forked from Void Editor and VS Code.

## ✨ Features

- AI-powered code completion and generation
- Built-in AI chat assistant
- Advanced code navigation and refactoring
- Cross-platform support (Windows, macOS, Linux)
- Extensible architecture with a rich extension ecosystem

## Project Structure

- `ainative-studio/` - The main IDE application (forked from Void Editor)
  - See [ainative-studio/README.md](ainative-studio/README.md) for detailed development setup
- `prd.md` - Product Requirements Document
- `dev_checklist.md` - Development checklist for the rebranding process

## 🚀 Quick Start

### Prerequisites

- Node.js 18.x or later (20.x recommended)
- npm 9.x or later
- Git
- Python 3.x (for native dependencies)
- Build tools for your platform

### Installation

```bash
# Clone the repository
git clone https://github.com/ainative/ainative.git

# Navigate to the project
cd ainative/ainative-studio

# Install dependencies
npm install
```

### Running the Application

#### Development Mode
```bash
# Start the build in watch mode (in one terminal)
npm run watch

# In another terminal, start the application
./scripts/code.sh
```

#### Production Build
```bash
# Build the application
npm run build

# Run the built application
./scripts/code.sh
```

For detailed platform-specific setup and troubleshooting, see the [ainative-studio README](ainative-studio/README.md).

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](ainative-studio/CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 Documentation

For detailed documentation, please visit our [documentation site](https://docs.ainative.studio).

## 📬 Contact

For support or questions, please open an issue in our [issue tracker](https://github.com/ainative/ainative/issues).

---

<p align="center">
  Made with ❤️ by AINative
</p>
