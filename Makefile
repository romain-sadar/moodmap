export PROJECT_NAME=moodmap
export TEST_PATH?=backend/tests
export COMPOSE_FILE?=docker-compose.yml
export WEB_CONTAINER=$$(docker ps -f "name=${PROJECT_NAME}_backend" --format {{.Names}} | head -n1)

build:
	@docker compose -p ${PROJECT_NAME} build

start:
	@docker compose up -d

stop:
	@docker compose stop

down:
	@docker compose down

restart: down start

pytest:
	@docker container exec ${WEB_CONTAINER} sh -c "cd /app/backend && pytest --ds=config.local -q ${TEST_PATH}"

print-container:
	@echo "Backend container: ${WEB_CONTAINER}"

shell:
	@echo "Web container: ${WEB_CONTAINER}"
	@docker container exec -it ${WEB_CONTAINER} bash
