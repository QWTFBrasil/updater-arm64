Build updater:

```
docker build --tag=updater .
```


Run updater:

```sh
docker run updater
```


Stop updater:

```sh
docker container ls
docker container stop <hash>
```


Deploy updater:

```sh
docker tag updater fortressone/updater:latest
docker push fortressone/updater:latest
```

Environment variables:

```
AWS_SECRET_ACCESS_KEY
AWS_ACCESS_KEY_ID
S3_DEMO_URI
S3_STATS_URI
```
