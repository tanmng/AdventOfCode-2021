WORK_IMAGE=julia

dev:
	docker run -it --rm \
		-v "`pwd`":/source \
		-w /source \
		--entrypoint bash \
		${WORK_IMAGE}

pulL:
	docker pull ${WORK_IMAGE}
