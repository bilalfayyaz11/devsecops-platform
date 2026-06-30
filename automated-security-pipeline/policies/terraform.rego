package terraform

default allow = false

# Allow the deployment only if there are no data configuration violations
allow {
    count(deny) == 0
}

# Rule to catch unauthorized port exposure
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "docker_container"
    
    # Access the port configuration block within the planned values
    port := resource.change.after.ports[_]
    
    # If the external port is exposed and is NOT 5000, 80, or 443, trigger a violation
    not valid_port(port.external)
    
    msg := sprintf("SECURITY VIOLATION: Container '%v' exposes unauthorized external port %v. Only ports 80, 443, and 5000 are permitted.", [resource.name, port.external])
}

# Helper to validate allowed ports
valid_port(p) { p == 5000 }
valid_port(p) { p == 80 }
valid_port(p) { p == 443 }
