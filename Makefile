SRCS 			= ./srcs
DOCKER			= docker

all		:	build

# Build image named ft_server
build	:
			$(DOCKER) build -t ft_server .

# Run container from image ft_server with -it option
rit		:
			$(DOCKER) run -it --rm -p 80:80 -p 443:443 --name ft_server ft_server

r		:
			$(DOCKER) run --rm -p 80:80 -p 443:443 --name ft_server ft_server

fclean	:
			$(DOCKER) image prune --force

re		:	fclean all
