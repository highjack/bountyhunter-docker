FROM debian:testing
#base packages
RUN apt-get -y update
RUN apt-get -y install tmux zsh wget git curl locales python python3 python3-pip golang cargo rustc libssl-dev build-essential vim fzf libpcap-dev
ENV GO111MODULE on
#environment
ENV TERM xterm
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8
ENV HOME /root/tools
#customize zsh and tmux
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf
RUN cp .tmux/.tmux.conf.local .
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN chsh -s "/bin/zsh"
COPY ./configs/zshrc /root/.zshrc
#RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="rkj-repos"/' ~/.zshrc
RUN mkdir -p /root/tools
#nmap
RUN apt-get -y install nmap
#altdns
RUN pip3 install py-altdns
RUN go get -v github.com/OWASP/Amass/v3/...
RUN cp /root/go/bin/amass /usr/bin/ | true
#Arjun
RUN pip3 install requests
RUN git clone https://github.com/s0md3v/Arjun.git /root/tools/Arjun
COPY ./scripts/arjun /usr/bin/
RUN chmod +x /usr/bin/arjun
#Dirsearch
RUN git clone https://github.com/maurosoria/dirsearch.git /root/tools/dirsearch
COPY ./scripts/dirsearch /usr/bin/
RUN chmod +x /usr/bin/dirsearch
#ffuf
RUN go get github.com/ffuf/ffuf; exit 0
RUN cp /root/tools/go/bin/ffuf /usr/bin/ | true
RUN git clone https://github.com/Edu4rdSHL/findomain.git /root/tools/findomain
#findomain
WORKDIR /root/tools/findomain
RUN cargo build --release
RUN cp /root/tools/findomain/target/release/findomain /usr/bin | true
#httprobe
RUN go get -u github.com/tomnomnom/httprobe
RUN cp /root/tools/go/bin/httprobe /usr/bin/ | true
#massdns
RUN git clone https://github.com/blechschmidt/massdns.git /root/tools/massdns
WORKDIR /root/tools/massdns
RUN make
RUN mv bin/massdns /usr/bin/
#meg
RUN go get -u github.com/tomnomnom/meg
RUN cp /root/tools/go/bin/meg /usr/bin | true
#masscan
RUN git clone https://github.com/robertdavidgraham/masscan /root/tools/masscan
WORKDIR /root/tools/masscan
RUN make
RUN make install

#start up
WORKDIR /root
ENTRYPOINT ["/bin/zsh"]
