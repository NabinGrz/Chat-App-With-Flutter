# Flutter Chat Application

This is a simple Flutter chat application developed to demonstrate the implementation of Riverpod for state management, Clean Architecture for project structure, and Socket for real-time messaging. The application allows users to create group chats, invite others to group or private chats, send and receive messages, and share images in real-time.

## Features

- **Create Group Chat:** Users can create group chats to communicate with multiple people simultaneously.
- **Invite to Group/Private Chat:** Users can invite others to join group chats or initiate private chats.
- **Send/Receive Messages/Images:** Users can send and receive text messages and images in real-time.
- **Login/Register:** Authentication system allowing users to log in or register to access the chat functionality.

## Technologies Used

- **Flutter:** The frontend framework used for building the cross-platform mobile application.
- **Riverpod:** State management library used for managing application state in a predictable manner.
- **Clean Architecture:** A software design approach that emphasizes separation of concerns, making the codebase more scalable and maintainable.
- **Socket:** Real-time communication protocol used for enabling instant messaging between users.
- **Node.js Backend:** Utilizes a backend built with Node.js to handle user authentication and message storage using a free API service.


## Backend

The backend for this application is used from a https://freeapi.app/. All user authentication and message storage functionalities are handled by this backend. No additional setup is required for the backend as it is already deployed and managed by the free API service.

## Folder Structure

The project follows a clean architecture folder structure for better organization and maintainability:

- **data:** Contains data layer implementations, including repositories and data sources.
- **domain:** Contains domain layer entities, use cases, and repository interfaces.
- **presentation:** Contains presentation layer components, including UI screens, widgets, and controllers.
- **core:** Contains core functionalities and utilities used across the application.

## Contributing

Contributions are welcome! If you find any bugs or have suggestions for improvement, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use and modify the code as per your requirements.

## Acknowledgments

Special thanks to the Flutter and Riverpod communities for their invaluable resources and support during the development of this project.

--- 

Feel free to customize this README file according to your project's specific details and requirements. Happy coding! 🚀
