# Budgetier

Budgetier is a personal finance application combining a Flutter mobile app with a NestJS (TypeScript) backend server. It helps users track spending and manage budgets on the go.

## Setup

1. Clone this repository.
2. Install dependencies for each component.

### Server
```bash
cd server
npm install
```

### Mobile
Ensure [Flutter](https://flutter.dev/docs/get-started/install) is installed, then run:
```bash
cd mobile/budgetier_app
flutter pub get
```

## Running

### Server
```bash
cd server
npm run start
```
The API will be available at `http://localhost:3000`.

### Mobile
Connect a device or emulator and run:
```bash
cd mobile/budgetier_app
flutter run
```

## Contributing

1. Fork the repository and create a feature branch.
2. Follow existing code style and run available lint or test commands.
3. Submit a pull request for review.

## License

This project is licensed under the MIT License.

## Resources

- Backend API documentation: `http://localhost:3000/api`
- [NestJS Documentation](https://docs.nestjs.com)
- [Flutter Documentation](https://flutter.dev/docs)
