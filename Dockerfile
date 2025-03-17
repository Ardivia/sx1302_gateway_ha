# Use Debian as the base image
FROM debian:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    libncurses5-dev \
    libfftw3-dev \
    libusb-1.0-0-dev \
    gpiod \
    jq \
    curl \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /sx1302_hal

# Clone the sx1302_hal repository
RUN git clone https://github.com/Lora-net/sx1302_hal.git .

# Compile the project
RUN make all

# Set the working directory for the packet forwarder
WORKDIR /sx1302_hal/packet_forwarder

# Copy the startup script and the reset script
COPY run.sh /sx1302_hal/packet_forwarder/run.sh
COPY reset_lgw.sh /sx1302_hal/packet_forwarder/reset_lgw.sh
RUN chmod +x /sx1302_hal/packet_forwarder/run.sh
RUN chmod +x /sx1302_hal/packet_forwarder/reset_lgw.sh

#Expose port for health check
EXPOSE 8080

# Define the command to run on startup
ENTRYPOINT ["/sx1302_hal/packet_forwarder/run.sh"]
