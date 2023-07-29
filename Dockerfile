FROM node:16.19.1-slim as base

LABEL "com.github.actions.name"="Release With Feature Upload"
LABEL "com.github.actions.description"="This action will create your release with feature upload via the GitHub Release API"
LABEL "com.github.actions.author"="StilosDesign"
LABEL "com.github.actions.color"="green"
LABEL "com.github.actions.icon"="play"

LABEL "repository"="http://github.com/stilosdesign/release-with-feature-upload"
LABEL "homepage"="https://github.com/stilosdesign/release-with-feature-upload"
LABEL "maintainer"="Antoniel Bordin <stilosdesign@hotmail.com>"

RUN apt update
RUN apt install -y git jq

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]