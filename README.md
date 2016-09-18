# s3strm/movies

The bucket holding the movie data

## Deps

s3strm/posters

## Workflow

New videos to be processed come in at:
```
    s3://<bucket_name>/incoming/<imdb_id>.mp4
```

There is a processor which then sends the files to:

```
    s3://<bucket_name>/processed/<imdb_id>/video.mp4
    s3://<bucket_name>/processed/<imdb_id>/sample.mp4
    s3://<bucket_name>/processed/<imdb_id>/metadata.nfo
```
