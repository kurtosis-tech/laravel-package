postgres = import_module("github.com/kurtosis-tech/postgres-package/main.star")
# nginx = import_module("github.com/kurtosis-tech/nginx-package/main.star")
nginx = import_module("/nginx/nginx.star")
laravel_app = import_module("/laravel-app/app.star")

# Postgres defaults
DEFAULT_POSTGRES_SERVICE_NAME = "postgres"
DEFAULT_POSTGRES_IMAGE_NAME = "postgres:alpine"
DEFAULT_POSTGRES_USER = "postgres"
DEFAULT_POSTGRES_PASSWORD = "secretdatabasepassword"
DEFAULT_POSTGRES_DB_NAME = "laravel-db"


# Nginx defaults
DEFAULT_NGINX_SERVICE_NAME = "nginx"
DEFAULT_NGINX_IMAGE_NAME = "nginx:latest"
DEFAULT_NGINX_CONFIG_FILE_ARTIFACT = "/nginx/default.conf"
DEFAULT_NGINX_ROOT_DIRPATH = "/var/www/public"

def run(
    plan,
    postgres_service_name=DEFAULT_POSTGRES_SERVICE_NAME,
    postgres_image=DEFAULT_POSTGRES_IMAGE_NAME,
    postgres_db_name=DEFAULT_POSTGRES_DB_NAME,
    postgres_user=DEFAULT_POSTGRES_USER,
    postgres_password=DEFAULT_POSTGRES_PASSWORD,
    nginx_service_name= DEFAULT_NGINX_SERVICE_NAME,
    nginx_image_name=DEFAULT_NGINX_IMAGE_NAME,
    ):

    """
    Starts this Laravel example application.

    Args:
        postgres_service_name (string): the Postgres's service name (default: postgres)
        postgres_image (string): the Postgres's container image name and label (default: postgres:alpine)
        postgres_user (string): the Postgres's user name (default: postgres)
        postgres_password (string): the Postgres's password (default: secretdatabasepassword)
        postgres_db_name (string): the Postgres's db name (default: laravel-db)
        nginx_service_name (string): the Nginx's service name (default: nginx)
        nginx_image_name (string): the Nginx's container image name and label (default: nginx:latest)
    """

    # run the application's db
    postgres_db = postgres.run(
        plan,
        service_name=postgres_service_name,
        image=postgres_image,
        user=postgres_user,
        password=postgres_password,
        database=postgres_db_name,
    )

    laravel_app.run(plan, postgres_db, postgres_password)

    # uploading the nginx config file
    nginx_config = plan.upload_files(
        src="/nginx/default.conf/",
        name="nginx_config",
    )

    # upload root files
    nginx_public_files = plan.upload_files(
        src="/laravel-app/files/public",
        name="nginx_public_files",
    )

    nginx_args = {
        "name":nginx_service_name,
        "image":nginx_image_name,
        "config_files_artifact":nginx_config,
        "root_dirpath":DEFAULT_NGINX_ROOT_DIRPATH,
        "root_file_artifact_name":nginx_public_files,
    }

    nginx.run(
        plan,
        args= nginx_args,
    )

    get_request_recipe = GetHttpRequestRecipe(
        port_id = "http",
        endpoint = "/",
    )

    plan.wait(
        service_name = nginx_service_name,
        recipe = get_request_recipe,
        field = "code",
        assertion = "==",
        target_value = 200,
        interval = "1s",
        timeout = "5m",
    )
