FROM nickblah/lua:5.1.5-luarocks-ubuntu

RUN ln -s /lib/x86_64-linux-gnu/librt.so.1 /lib/librt.so && \
	apt update && \
	apt-get install gcc -y && \
	luarocks install busted

CMD ["lua"]