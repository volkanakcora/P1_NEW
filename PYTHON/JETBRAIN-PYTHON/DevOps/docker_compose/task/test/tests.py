import difflib
import logging
from pathlib import Path

import docker
import requests
from hstest import StageTest, dynamic_test, CheckResult

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

docker_file = "docker-compose.yaml"
stage = Path(__file__).parent.parent

test_network = "hyper-task-manager-network"
test_volume = "mongo-data"
test_images = ["mongo:6.0.8", "hyper-service"]
test_mongo_envs = ['MONGO_INITDB_ROOT_USERNAME=admin', 'MONGO_INITDB_ROOT_PASSWORD=84225adce^/']
test_fastapi_envs = ['MONGO_INITDB_ROOT_USERNAME=admin', 'MONGO_INITDB_ROOT_PASSWORD=84225adce^/',
                     'MONGO_HOST_NAME: mongodb', 'MONGO_PORT_NUMBER: 27017']


class DockerTest(StageTest):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.output = None
        self.client = docker.from_env()

    @staticmethod
    def compare_files(test_file_path, user_file_path):
        """Tests the contents of files line by line"""
        try:
            with open(test_file_path, 'r') as file1:
                test_file_content = file1.readlines()
        except FileNotFoundError:
            return CheckResult.wrong(f"Could not find {test_file_path}")
        try:
            with open(user_file_path, 'r') as file2:
                user_file_content = file2.readlines()
        except FileNotFoundError:
            return CheckResult.wrong(f"Could not find {user_file_path}")

        try:
            # removing trailing newlines, empty lines, and adding a newline
            test_file_data = [line.rstrip() + "\n" for line in test_file_content if not line.isspace()]
            user_file_data = [line.rstrip() + "\n" for line in user_file_content if not line.isspace()]

            # Converting generator object to list
            wrong_lines = list(
                difflib.unified_diff(
                    test_file_data,
                    user_file_data,
                    fromfile="test-file",
                    tofile="user-file",
                    lineterm='\n')
            )
        except:
            return CheckResult.wrong("Error while comparing test and user file!")

        if not wrong_lines:
            return CheckResult.correct()

        return CheckResult.wrong(
            f"Wrong line(s) found in the user file\n"
            f"{''.join(wrong_lines)}"
        )

    @dynamic_test()
    def test1(self):
        """Tests the content of the `main.py`"""
        file1_path = f"{stage}/test/test-main.txt"
        file2_path = f"{stage}/task-manager/main.py"
        return self.compare_files(file1_path, file2_path)

    @dynamic_test()
    def test2(self):
        """Tests if the base image exists in the system"""
        images_text = " ".join([str(image) for image in self.client.images.list()])
        for image in test_images:
            if image not in images_text:
                return CheckResult.wrong(f"'{image}' not found in the system images!")

        return CheckResult.correct()

    @dynamic_test()
    def test3(self):
        """Tests that network exists in the system"""
        network_names = "".join(network.attrs.get("Name") for network in self.client.networks.list())
        if test_network not in network_names:
            return CheckResult.wrong(f"'{test_network}' not found in the system networks!")

        return CheckResult.correct()

    @dynamic_test()
    def test4(self):
        """Tests that volume exists in the system"""
        volume_names = "".join(volume.attrs.get("Name") for volume in self.client.volumes.list())
        if test_volume not in volume_names:
            return CheckResult.wrong(f"'{test_volume}' not found in the system volumes!")

        return CheckResult.correct()

    @dynamic_test()
    def test5(self):
        """Tests image of container, state,exposed port, and host port"""
        all_containers = self.client.containers.list(all=True)
        container_name = "hyper-mongo"
        exposed_port = "27017/tcp"
        host_port = "27027"
        status = "running"
        selected_container = None

        for container in all_containers:
            # Finds the container object to test
            if container_name in container.name:
                selected_container = container

        if not selected_container:
            # Fails if the expected container is not found
            return CheckResult.wrong(f"Couldn't find a container with the name '{container_name}'!")

        if status not in selected_container.status:
            # Fails if the container is not running
            return CheckResult.wrong(f"The container should be {status}!")

        host_ports = selected_container.ports.get(exposed_port)

        if not host_ports:
            # Fails if the exposed port is wrong and returns None
            return CheckResult.wrong(f"The exposed port should be {exposed_port} and need to be mapped to a host port!")

        host_ports_str = "_".join(item.get("HostPort", "_") for item in host_ports)

        if host_port not in host_ports_str:
            # Fails if the host port is wrong
            return CheckResult.wrong(f"You should map {exposed_port} to {host_port}!")

        if not selected_container.attrs or \
                not selected_container.attrs.get("Config") or \
                not selected_container.attrs.get("Config").get("Env"):
            # Tests if environments exists
            return CheckResult.wrong(f"Environments are not defined!")

        container_envs = selected_container.attrs.get("Config").get("Env")

        for env in test_mongo_envs:
            # Tests if environments are defined
            if env not in container_envs:
                return CheckResult.wrong(f"Environment `{env}` not found!")

        if not selected_container.attrs.get("NetworkSettings") or \
                not selected_container.attrs.get("NetworkSettings").get("Networks"):
            # Tests if container network mode exists
            return CheckResult.wrong("Could not read networks from container!")

        container_networks = "*".join(selected_container.attrs.get("NetworkSettings").get("Networks").keys())
        if test_network not in container_networks:
            # Tests if container network is correct
            return CheckResult.wrong("The container network is wrong!")

        if not selected_container.attrs.get("Mounts") or \
                not selected_container.attrs.get("Mounts")[0].get("Name"):
            # Tests if container volume exists
            return CheckResult.wrong(
                "Could not read volume from container!")

        # Tests if container volume is correct
        mounts = selected_container.attrs.get("Mounts", [])
        is_volume_found = False
        for mount in mounts:
            if test_volume in mount.get("Name"):
                is_volume_found = True

        if not is_volume_found:
            return CheckResult.wrong("The container volume is wrong!")

        return CheckResult.correct()

    @dynamic_test()
    def test6(self):
        """Tests image of container, state,exposed port, and host port"""
        all_containers = self.client.containers.list(all=True)
        container_name = "hyper-task-manager"
        exposed_port = "8000/tcp"
        host_port = "8000"
        status = "running"
        selected_container = None

        for container in all_containers:
            # Finds the container object to test
            if container_name in container.name:
                selected_container = container

        if not selected_container:
            # Fails if the expected container is not found
            return CheckResult.wrong(f"Couldn't find a container with the name '{container_name}'!")

        if status not in selected_container.status:
            # Fails if the container is not running
            return CheckResult.wrong(f"The container should be {status}!")

        host_ports = selected_container.ports.get(exposed_port)

        if not host_ports:
            # Fails if the exposed port is wrong and returns None
            return CheckResult.wrong(f"The exposed port should be {exposed_port} and need to be mapped to a host port!")

        host_ports_str = "_".join(item.get("HostPort", "_") for item in host_ports)

        if host_port not in host_ports_str:
            # Fails if the host port is wrong
            return CheckResult.wrong(f"You should map {exposed_port} to {host_port}!")

        if not selected_container.attrs or \
                not selected_container.attrs.get("Config") or \
                not selected_container.attrs.get("Config").get("Env"):
            # Tests if environments exists
            return CheckResult.wrong(f"Environments are not defined!")

        container_envs = selected_container.attrs.get("Config").get("Env")

        for env in test_mongo_envs:
            # Tests if environments are defined
            if env not in container_envs:
                return CheckResult.wrong(f"Environment `{env}` not found!")

        if not selected_container.attrs.get("NetworkSettings") or \
                not selected_container.attrs.get("NetworkSettings").get("Networks"):
            # Tests if container network mode exists
            return CheckResult.wrong("Could not read networks from container!")

        container_networks = "*".join(selected_container.attrs.get("NetworkSettings").get("Networks").keys())
        if test_network not in container_networks:
            # Tests if container network is correct
            return CheckResult.wrong("The container network is wrong!")

        return CheckResult.correct()

    @dynamic_test()
    def test7(self):
        """Tests the content of the `main.py`"""
        file1_path = f"{stage}/test/test-main.txt"
        file2_path = f"{stage}/task-manager/main.py"
        r = self.compare_files(file1_path, file2_path)
        if not r:
            return CheckResult.wrong("The content of the `main.py` is wrong. Please fix it!")
        if isinstance(r, str):
            return CheckResult.wrong(r)
        return CheckResult.correct()

    @dynamic_test()
    def test8(self):
        """Tests the API and if one of the task exists in database"""

        url = 'http://localhost:8000/tasks/title/Study'

        headers = {
            'Content-Type': 'application/json',
        }

        response = requests.get(url, headers=headers)

        if response.status_code != 200:
            return CheckResult.wrong(
                f"GET request failed with status code: {response.status_code}.\nMake sure you rebuild the image, after you fix the typo.")

        if response.json().get("description") != "Study DevOps":
            return CheckResult.wrong(
                "Description fot the the title `Study` is wrong, check if you have created the task!")

        return CheckResult.correct()


if __name__ == '__main__':
    DockerTest().run_tests()