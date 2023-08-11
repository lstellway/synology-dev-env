# Run Docker compose commands against the development file
dev-compose = docker-compose --file docker-compose.yml $(1)

# Initialize the development environment
.PHONY: dev
dev:
	@echo "Starting development environment..."
	$(call dev-compose, up -d --build)

# Stop the development environment
.PHONY: down
down:
	@echo "Stopping development environment..."
	$(call dev-compose, down)

# Initialize a terminal session in the development admin container
.PHONY: shell
shell:
	@echo "Initializing terminal session..."
	$(call dev-compose, exec -it synology-dev-env /bin/bash -l)

copy-results:
	docker cp synology-dev-env:/data/toolkit/result_spk .
