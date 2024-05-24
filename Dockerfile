# Start from the Rust image
FROM rust:1.78 as base

# Install any necessary dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    pkg-config

# Set the working directory
WORKDIR /usr/src/app

# Copy the current directory contents into the container
COPY . .

# Build the application
RUN cargo build --release

# Create a new stage for development
FROM base as dev

# Set the environment to development
ENV RUST_ENV=development

# Install any additional tools you need for development
RUN cargo install cargo-watch

# Expose any ports your application uses
EXPOSE 8000

CMD ["cargo", "watch", "-x", "run"]