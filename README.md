## MOTASY
### Automation of an induction motor with an arduino application and system

## API Setup (Node.js)

### Prerequisites:
- **Node.js** (v14 or higher)
- **npm** (Node package manager)

### Steps to Set Up:

1. **Clone the repository** (if you haven't already):
    ```bash
    git clone <your-repository-url>
    cd <your-repository-folder>
    ```

2. **Install dependencies**:
    In your project folder, run the following command to install all necessary dependencies:
    ```bash
    npm install
    ```

3. **Set up environment variables**:
    - Create a `.env` file in the root directory of the project.
    - Add the following variables inside the `.env` file:
    ```
    PORT=5000  # The port where the API will run
    JWT_SECRET=your_jwt_secret_here  # Set a secret for signing JWTs
    API_URL=http://localhost:5000  # URL of your API (for Flutter app)
    ```

4. **Run the API server**:
    Start the server by running:
    ```bash
    node server.js
    ```
    The server will be accessible at `http://localhost:5000`.

---

## Flutter Application Setup

### Prerequisites:
- **Flutter** SDK (latest stable version)
- **Dart** SDK (comes with Flutter)
- **Android Studio** or **VS Code** (with Flutter plugin)

### Steps to Set Up:

1. **Clone the Flutter project** (if you haven't already):
    ```bash
    git clone <your-flutter-repository-url>
    cd <your-flutter-project-folder>
    ```

2. **Install dependencies**:
    In your project folder, run the following command to install the required dependencies:
    ```bash
    flutter pub get
    ```

3. **Set up environment variables**:
    - In the Flutter app, ensure the API URL is correctly set for your backend.
    - Open the `.env` -> assets/.env file in your Flutter project and add your API URL:
    ```
    API_URL=http://localhost:5000  # The URL of your Node.js API server
    JWT_SECRET=secret_token 
    ```

4. **Run the Flutter app**:
    To run the application on your emulator or connected device, use the following command:
    ```bash
    flutter run
    ```
