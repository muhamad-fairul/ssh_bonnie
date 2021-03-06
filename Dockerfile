FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y gcc g++
RUN apt-get install -y openmpi-bin
RUN apt-get install -y build-essential
RUN mkdir /var/run/sshd
RUN mkdir /bonnie
WORKDIR /bonnie
RUN pwd
RUN echo 'root:Intel123!' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

#SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN wget http://www.coker.com.au/bonnie++/bonnie++-1.03e.tgz
RUN tar zxvf bonnie++-1.03e.tgz
WORKDIR bonnie++-1.03e
RUN ./configure
RUN make
RUN make install

#run bonnie
RUN bonnie++ -u root >> bonnie_result.txt
RUN cat bonnie_result.txt
RUN ls
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
