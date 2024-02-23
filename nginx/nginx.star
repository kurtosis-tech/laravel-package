NAME_ARG = "name"
IMAGE_ARG = "image"
PORT_ID = "port_id"
PORT_NUMBER = "port_number"
CONFIG_FILES_ARTIFACT_ARG = "config_files_artifact"
ROOT_DIRPATH = "root_dirpath"
ROOT_FILE_ARTIFACT = "root_file_artifact_name"
DEFAULT_SERVICE_NAME = "nginx"
DEFAULT_IMAGE = "nginx:latest"
DEFAULT_CONFIG_FILEPATH = "/etc/nginx/conf.d"
DEFAULT_PORT_ID = "http"
DEFAULT_PORT_NUMBER = 80
HTTP_PORT_APP_PROTOCOL = "http"

def run(plan, args = {}):
    name = args.get(NAME_ARG, DEFAULT_SERVICE_NAME)
    image = args.get(IMAGE_ARG, DEFAULT_IMAGE)
    port_id = args.get(PORT_ID, DEFAULT_PORT_ID)
    port_number = args.get(PORT_NUMBER, DEFAULT_PORT_NUMBER)
    config_file_artifact = args.get(CONFIG_FILES_ARTIFACT_ARG, "")
    root_dirpath = args.get(ROOT_DIRPATH, "")
    root_file_artifact = args.get(ROOT_FILE_ARTIFACT, "")

    files = {}
    if config_file_artifact != "":
        files[DEFAULT_CONFIG_FILEPATH] = config_file_artifact
        
    if root_dirpath != "" and root_file_artifact != "":
        files[root_dirpath] = root_file_artifact

    nginx_service = plan.add_service(
        name = name,
        config = ServiceConfig(
            image = image,
            ports = {
                port_id: PortSpec(number = port_number, application_protocol = HTTP_PORT_APP_PROTOCOL)
            },
            files = files,
        )
    )

    return nginx_service
