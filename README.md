# 🛍️ EasyShop - Modern E-commerce Platform

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

EasyShop is a modern, full-stack e-commerce platform built with Next.js 14, TypeScript, and MongoDB. It features a beautiful UI with Tailwind CSS, secure authentication, real-time cart updates, and a seamless shopping experience.

## 📚 About This Repository

This project is a **DevOps practice repository** based on the original [EasyShop project by Md. Afzal Hassan Ehsani](https://github.com/iemafzalhassan/easyshop). The original application showcases excellent e-commerce development practices, and I am using it as a foundation to practice and implement **DevOps, Infrastructure as Code, CI/CD pipelines, and DevSecOps principles**.

### What I'm Practicing:

- **Terraform**: Writing Infrastructure as Code (IaC) to provision and manage cloud resources
- **Docker & Kubernetes**: Containerizing applications and orchestrating deployments
- **CI/CD Pipelines**: Building automated pipelines using Jenkins for continuous integration and deployment
- **DevSecOps**: Implementing security best practices throughout the development and deployment lifecycle
- **Git-based Deployments**: Using ArgoCD for GitOps-based application deployments
- **Infrastructure Automation**: Scripting deployment and configuration automation
- **Monitoring & Observability**: Setting up monitoring and logging for deployed applications

## ✨ Features

- 🎨 Modern and responsive UI with dark mode support
- 🔐 Secure JWT-based authentication
- 🛒 Real-time cart management with Redux
- 📱 Mobile-first design approach
- 🔍 Advanced product search and filtering
- 💳 Secure checkout process
- 📦 Multiple product categories
- 👤 User profiles and order history
- 🌙 Dark/Light theme support

## 🏗️ Architecture

EasyShop follows a three-tier architecture pattern:

### 1. Presentation Tier (Frontend)
- Next.js React Components
- Redux for State Management
- Tailwind CSS for Styling
- Client-side Routing
- Responsive UI Components

### 2. Application Tier (Backend)
- Next.js API Routes
- Business Logic
- Authentication & Authorization
- Request Validation
- Error Handling
- Data Processing

### 3. Data Tier (Database)
- MongoDB Database
- Mongoose ODM
- Data Models
- CRUD Operations
- Data Validation


### Key Features of the Architecture
- **Separation of Concerns**: Each tier has its specific responsibilities
- **Scalability**: Independent scaling of each tier
- **Maintainability**: Modular code organization
- **Security**: API routes handle authentication and data validation
- **Performance**: Server-side rendering and static generation
- **Real-time Updates**: Redux for state management

### Data Flow
1. User interacts with React components
2. Actions are dispatched to Redux store
3. API clients make requests to Next.js API routes
4. API routes process requests through middleware
5. Business logic handles data operations
6. Mongoose ODM interacts with MongoDB
7. Response flows back through the tiers

## 🚀 Getting Started

### Docker Setup Guide

This guide will help you run EasyShop using Docker containers. No local Node.js or MongoDB installation required!

### Prerequisites

1. Install [Docker](https://docs.docker.com/get-docker/) on your machine
2. Basic understanding of terminal/command line

### Step 1: Environment Setup

1. Create a file named `.env.local` in the root directory with the following content:
```env
# Database Configuration
MONGODB_URI=mongodb://easyshop-mongodb:27017/easyshop

# NextAuth Configuration
NEXTAUTH_URL=http://localhost:3000  # Replace with your EC2 instance's public IP or put localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:3000/api  # Replace with your EC2 instance's public IP or put localhost:3000/api
NEXTAUTH_SECRET=your-nextauth-secret-key  # Generate this using the command below

# JWT Configuration
JWT_SECRET=your-jwt-secret-key  # Generate this using the command below
```

> [!IMPORTANT]
> When deploying to EC2, make sure to replace `your-ec2-ip` with your actual EC2 instance's public IP address.

To generate secure secret keys, use these commands in your terminal:
```bash
# For NEXTAUTH_SECRET
openssl rand -base64 32

# For JWT_SECRET
openssl rand -hex 32
```

### Step 2: Running the Application

You have two options to run the application:

#### Option 1: Using Docker Compose (Recommended)

This is the easiest way to run the application. All services will be started in the correct order with proper dependencies.

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop all services
docker compose down
```

#### Option 2: Manual Docker Commands

If you prefer more control, you can run each service manually:

1. Create a Docker network:
```bash
docker network create easyshop-network
```

2. Start MongoDB:
```bash
docker run -d \
  --name easyshop-mongodb \
  --network easyshop-network \
  -p 27017:27017 \
  -v mongodb_data:/data/db \
  mongo:latest
```

3. Build the main application:
```bash
docker build -t easyshop .
```

4. Build and run data migration:
```bash
# Build migration image
docker build -t easyshop-migration -f scripts/Dockerfile.migration .

# Run migration
docker run --rm \
  --network easyshop-network \
  --env-file .env.local \
  easyshop-migration
```

5. Start the EasyShop application:
```bash
docker run -d \
  --name easyshop \
  --network easyshop-network \
  -p 3000:3000 \
  --env-file .env.local \
  easyshop:latest
```

### Accessing the Application

1. Open your web browser
2. Visit [http://localhost:3000](http://localhost:3000)
3. You should see the EasyShop homepage!

### Useful Docker Commands

```bash
# View running containers
docker ps

# View container logs
docker logs easyshop
docker logs easyshop-mongodb

# Stop containers
docker stop easyshop easyshop-mongodb

# Remove containers
docker rm easyshop easyshop-mongodb

# Remove network
docker network rm easyshop-network
```

### Troubleshooting

1. If you can't connect to MongoDB:
   - Make sure the MongoDB container is running: `docker ps`
   - Check MongoDB logs: `docker logs easyshop-mongodb`
   - Verify network connection: `docker network inspect easyshop-network`

2. If the application isn't accessible:
   - Check if the container is running: `docker ps`
   - View application logs: `docker logs easyshop`
   - Make sure port 3000 isn't being used by another application

3. If migration fails:
   - Check if MongoDB is running and accessible
   - View migration logs when running the migration command
   - Verify your .env.local file has the correct MongoDB URI

For any other issues, please create a GitHub issue with the error details.

## 🧪 Testing

> [!NOTE]
> Coming soon: Unit tests and E2E tests with Jest and Cypress

## 🔧 Troubleshooting

### Build Errors

1. **Dynamic Server Usage Warnings**
```bash
Error: Dynamic server usage: Page couldn't be rendered statically
```
**Solution**: This is expected behavior for dynamic routes and API endpoints. These warnings appear during build but won't affect the application's functionality.

2. **MongoDB Connection Issues**
```bash
Error: MongoDB connection failed
```
**Solution**: 
- Ensure MongoDB is running locally
- Check if your MongoDB connection string is correct in `.env.local`
- Try connecting to MongoDB using MongoDB Compass with the same connection string

### Development Tips
- Clear `.next` folder if you encounter strange build issues: `rm -rf .next`
- Run `npm install` after pulling new changes
- Make sure all environment variables are properly set
- Use Node.js version 18 or higher

## 📦 Project Structure

```
easyshop/
├── src/
│   ├── app/              # Next.js App Router pages
│   ├── components/       # Reusable React components
│   ├── lib/             # Utilities and configurations
│   │   ├── auth/        # Authentication logic
│   │   ├── db/          # Database configuration
│   │   └── features/    # Redux slices
│   ├── types/           # TypeScript type definitions
│   └── styles/          # Global styles and Tailwind config
├── public/              # Static assets
└── scripts/            # Database migration scripts
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Run tests: `npm test` (coming soon)
5. Commit your changes: `git commit -m 'Add amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

> [!TIP]
> Check our [Contributing Guidelines](CONTRIBUTING.md) for more details

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Next.js](https://nextjs.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [MongoDB](https://www.mongodb.com/)
- [Redux Toolkit](https://redux-toolkit.js.org/)
- [Radix UI](https://www.radix-ui.com/)

## 📫 Contact

For questions or feedback, please open an issue or contact the maintainers:

- Maintainer - [@Md. Afzal hassan Ehsani](https://github.com/iemafzalhassan)
- Project Link: [https://github.com/iemafzalhassan/easyshop](https://github.com/iemafzalhassan/easyshop)

---

<div align="center">
  <p>
    Made with ❤️ by <a href="https://iemafzalhassan.tech" target="_blank"><b>Md. Afzal Hassan Ehsani</b></a>
  </p>
</div>


# EasyShop Deployment & DevOps

## 🚀 DevOps Section

> [!NOTE]
> This section is under development and will be updated with detailed information about the DevOps setup, CI/CD pipeline configuration, infrastructure deployment, and best practices as the project evolves.

## DevOps Practices

### Using Terraform

Terraform is used for infrastructure as code (IaC) in this project. To set up the infrastructure, follow these steps:

1. **Install Terraform**: Ensure you have Terraform installed on your machine. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html).

2. **Initialize Terraform**: Navigate to the `terraform` directory and run the following command to initialize the Terraform configuration:
   ```bash
   cd terraform
   terraform init
   ```

3. **Plan the Infrastructure**: To see what changes will be made, run:
   ```bash
   terraform plan
   ```

4. **Apply the Configuration**: To create the infrastructure, execute:
   ```bash
   terraform apply
   ```
   Confirm the action when prompted.

5. **Destroy the Infrastructure**: If you need to tear down the infrastructure, use:
   ```bash
   terraform destroy
   ```
   Confirm the action when prompted.

### Using Jenkins CI Pipeline

Jenkins is used for continuous integration and deployment in this project. To set up the Jenkins pipeline, follow these steps:

1. **Install Jenkins**: Ensure you have Jenkins installed. You can download it from [Jenkins' official website](https://www.jenkins.io/download/).

2. **Create a New Pipeline**: In Jenkins, create a new pipeline job and configure it to point to your repository.

3. **Configure the Pipeline Script**: Use the following example script in your Jenkins pipeline configuration:
   ```groovy
   pipeline {
       agent any
       stages {
           stage('Build') {
               steps {
                   sh 'npm install'
               }
           }
           stage('Test') {
               steps {
                   sh 'npm test'
               }
           }
           stage('Deploy') {
               steps {
                   sh 'npm run deploy'
               }
           }
       }
   }
   ```

4. **Run the Pipeline**: Trigger the pipeline manually or set it to run automatically on code changes.

5. **Monitor the Pipeline**: Check the Jenkins dashboard for build status and logs.
