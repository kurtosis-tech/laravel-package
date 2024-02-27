APP_FILES_DIRPATH = "/laravel-app/files"
POSTGRES_DB_CONNECTION = "pgsql"


def run(plan, service_name, postgres_db, postgress_password):
    postgres_port = "{}".format(postgres_db.service.ports["postgresql"].number)

    # upload app files
    app_files = plan.upload_files(
        src=APP_FILES_DIRPATH,
        name="app-files",
    )

    service_config_build = ServiceConfig(
        image=ImageBuildSpec(
            image_name="kurtosistech/laravel-package",
            build_context_dir=APP_FILES_DIRPATH,
        ),
        env_vars={
            "DB_CONNECTION": POSTGRES_DB_CONNECTION,
            "DB_HOST": postgres_db.service.hostname,
            "DB_PORT": postgres_port,
            "DB_DATABASE": postgres_db.database,
            "DB_USERNAME": postgres_db.user,
            "DB_PASSWORD": postgress_password,
        },
        #entrypoint=["sh", "-c"],
        #cmd=[""],
        files={
            "/var/www": Directory(
                artifact_names=[app_files],
            ),
        },
    )

    laravel_app_service = plan.add_service(
        name=service_name,
        config=service_config_build,
    )

    return laravel_app_service
