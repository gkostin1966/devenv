FROM ruby

ARG UNAME=devenv
ARG UID=1000
ARG GID=1000

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y install --no-install-recommends \
      git \
      wget \
      vim

RUN groupadd -g $GID -o $UNAME && \
    useradd -m -d /$UNAME -u $UID -g $GID -o -s /bin/bash $UNAME

COPY --chown=$UID:$GID . /$UNAME

USER $UNAME

WORKDIR /$UNAME

RUN bundle install

CMD ["sleep", "infinity"]

