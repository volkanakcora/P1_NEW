'Introducing Container Technology
'

'Software containers are a way to package applications to simplify deployment and management.'



Comparing Containers to Virtual Machines

'Containers provide many of the same benefits as virtual machines, such as security, storage, and network isolation.

Both technologies isolate their application libraries and runtime resources from the host operating system or hypervisor and vice versa.'



'Containers and Virtual Machines are different in the way they interact with hardware and the underlying operating system.
'
#Virtualization:

1- Enables multiple operating systems to run simultaneously on a single hardware platform.

2- Uses a hypervisor to divide hardware into multiple virtual hardware systems, allowing multiple operating systems to run side by side.

3- Requires a complete operating system environment to support the application.

#Compare and contrast this with containers, which:

1- Run directly on the operating system, sharing hardware and OS resources across all containers on the system. This enables applications to stay lightweight and run swiftly in parallel.

2- Share the same operating system kernel, isolate the containerized application processes from the rest of the system, and use any software compatible with that kernel.

3- Require far fewer hardware resources than virtual machines, which also makes them quick to start and stop and reduces storage requirements.



'Red Hat Enterprise Linux implements containers using core technologies such as:
'
Control Groups (cgroups) for resource management.

Namespaces for process isolation.

SELinux and Seccomp (Secure Computing mode) to enforce security boundaries.


#Planning for Containers
Containers are an efficient way to provide reusability and portability of hosted applications. They can be easily moved from one environment to another, such as from development to production. 
You can save multiple versions of a container and quickly access each one as needed.


#Running Containers from Container Images

Containers are run from container images. Container images serve as blueprints for creating containers.

'Container images package an application together with all its dependencies, such as:
'
System libraries

Programming language runtimes

Programming language libraries

Configuration settings

Static data files


#Managing Containers with Podman


'A good way to start learning about containers is to work with individual containers on a single server acting as a container host. Red Hat Enterprise Linux provides a set of container tools that you can use to do this, including:
'
podman, 'which directly manages containers and container images.'

skopeo, 'which you can use to inspect, copy, delete, and sign images.
'
buildah, 'which you can use to create new container images.'


'Running Rootless Containers
'On the container host, you can run containers as the root user or as a regular, unprivileged user. Containers run by non-privileged users are 
called rootless containers.

Rootless containers are more secure, but have some restrictions. For example, rootless containers cannot publish their network services through the 
container hosts privileged ports (those below port 1024).

#Managing Containers at Scale


'Deploying containers at scale in production requires an environment that can adapt to some of the following challenges:
'
- The platform must ensure the availability of containers that provide essential services to customers.

- The environment must respond to application usage spikes by increasing or decreasing the running containers and load balancing the traffic.

- The platform should detect the failure of a container or a host and react accordingly.

-  Developers might need an automated workflow to transparently and securely deliver new application versions to customers.




'Kubernetes is an orchestration service that makes it easier for you to deploy, manage, and scale container-based applications across a cluster 
of container hosts. It helps manage DNS updates when you start new containers. It helps redirect traffic to your containers using a load balancer, 
which also allows you to scale up and down the number of containers providing a service manually or automatically. 
It also supports user-defined health checks to monitor your containers and to restart them if they fail.'

