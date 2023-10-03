# Nuxt 3 Docker Deployment
A Simple Dockerfile For Nuxt3


## How to use

### Build the image
```bash
docker build . -t nuxt3-template
```

### Start the container
```bash
docker run -p 3000:3000 nuxt3-template
```

### See if it's working
```bash
curl http://localhost:3000
```
