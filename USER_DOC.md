# User Documentation - Inception

## 1. Services Provided
This infrastructure provides a complete web hosting stack:
* **NGINX**: A high-performance web server acting as the secure entry point (HTTPS).
* **WordPress**: The content management system (CMS) to manage your website.
* **MariaDB**: The database engine that stores all your website's data.

## 2. How to Start and Stop the Project
The project is managed via a Makefile located at the root of the repository.

* **To start the project**: Open your terminal and run:
    ```bash
    make
    ```
    This will build the images and launch all services in the background.

* **To stop the project**: Run:
    ```bash
    make down
    ```

## 3. Accessing the Website and Admin Panel
### Prerequisites
Before accessing the site, you must ensure that your local machine recognizes the domain name. Add the following line to your `/etc/hosts` file:
`127.0.0.1 squement.42.fr`

### URLs
* **Main Website**: [https://squement.42.fr](https://squement.42.fr)
* **WordPress Admin Panel**: [https://squement.42.fr/wp-admin](https://squement.42.fr/wp-admin)

## 4. Managing Credentials
All sensitive information and credentials (usernames, passwords, database names) must be stored in an environment file with the format of `srcs/exemple.env`:
`./srcs/.env`

**Note**: For security reasons, this file is not included in the Git repository and must be managed locally.

## 5. Checking Service Status
To verify that all services are running correctly, you can use the following command:
```bash
docker ps