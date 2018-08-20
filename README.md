Dev Environment

sudo docker run --name some-nginx -v ~/IdeaProjects/TradingCards:/usr/share/nginx/html:ro -p 8080:80 nginx