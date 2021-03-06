.PHONY: run setup test setup_upgrade install_node setup_nvm lint clean

help:
	@echo '    setup .................... sets up project dependencies'
	@echo '    run ...................... runs project'
	@echo '    test ..................... runs tests'
	@echo '    setup_upgrade ............ upgrades project dependencies'
	@echo '    clean .................... deletes project dependencies'
	@echo '    install_node.............. sets up node version'
	@echo '    setup_nvm ................ sets up nvm'
	@echo '    lint ..................... runs code linter'

setup: install_node
	npm install

run:
	npm run start_dev

test:
	npm test
	$(MAKE) lint

setup_upgrade: clean
	npm install
	npm shrinkwrap

install_node:
	@if test -d ~/.nodenv; then \
		echo "Nodenv is already installed"; \
		bash -c "nodenv global 6.11.1"; \
	else \
		make setup_nvm; \
		bash -c "source ~/.nvm/nvm.sh && nvm install 6.11.1 && nvm use 6.11.1"; \
		echo "Add these lines to your bash_profile, bashrc ..."; \
		echo "	source ~/.nvm/nvm.sh"; \
		echo "	[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion"; \
	fi

setup_nvm:
	@if [ test -d ~/.nvm ]; then \
		echo "Nvm is already installed"; \
	else \
		curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash; \
	fi

lint:
	npm run lint

clean:
	-rm -rf node_modules

docker_build:
	docker build -t globobackstage/functions .

docker_push:
	docker push globobackstage/functions
