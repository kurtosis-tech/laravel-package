NAME_ARG = "name"
IMAGE_ARG = "image"
CONFIG_FILES_ARTIFACT_ARG = "config_files_artifact"
ROOT_DIRPATH = "root_dirpath"
ROOT_FILE_ARTIFACT = "root_file_artifact_name"

HTTP_PORT_NAME = "http"
HTTP_PORT_NUMBER = 80
HTTP_PORT_APP_PROTOCOL = "http"

def run(plan, args = {}):
    name = args.get(NAME_ARG, "nginx")
    image = args.get(IMAGE_ARG, "nginx:latest")
    config_file_artifact = args.get(CONFIG_FILES_ARTIFACT_ARG, "")
    root_dirpath = args.get(ROOT_DIRPATH, "")
    root_file_artifact = args.get(ROOT_FILE_ARTIFACT, "")

    files = {}
    if config_file_artifact != "":
        files = {
            "/etc/nginx/conf.d": config_file_artifact,
        }
    if root_dirpath != "" and root_file_artifact != "":
        files[root_dirpath] = root_file_artifact

    plan.print(files)

    nginx_service = plan.add_service(
        name = name,
        config = ServiceConfig(
            image = image,
            ports = {
                HTTP_PORT_NAME: PortSpec(number = HTTP_PORT_NUMBER, application_protocol = HTTP_PORT_APP_PROTOCOL)
            },
            files = files,
        )
    )

    return nginx_service
