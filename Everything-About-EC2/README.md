# Amazon EC2 (Elastic Compute Cloud)
Amazon EC2 (Elastic Compute Cloud) is like renting a computer in the cloud. You can use it to run applications just like you would on a computer in your office, but it's available online.
## Key Concepts
### 1. Instances
- **Description**: Think of an instance as a virtual computer in the cloud.
- **Real-World Example**: Imagine renting a laptop. You can choose the type of laptop based on your needs (e.g., lightweight for travel, powerful for gaming).
- **Types**:
 - **On-Demand Instances**: Pay for the virtual computer by the hour or second, like renting a car by the hour.
 - **Reserved Instances**: Commit to using the virtual computer for a year or three years in exchange for a discount, like signing a lease on an apartment.
 - **Spot Instances**: Bid on unused virtual computers at a lower price, similar to booking a last-minute flight deal.
 - **Why Needed**: Instances are the basic building blocks of EC2. They provide the computing power needed to run applications.
### 2. Amazon Machine Image (AMI)
- **Description**: A pre-packaged setup for your virtual computer.
- **Real-World Example**: It's like buying a new phone with the operating system and some apps already installed.
- **Types**:
 - **Public AMIs**: Provided by AWS or shared by others, like free apps in an app store.
 - **Private AMIs**: Created by you or your company, like custom settings and apps on your phone.
 - **Why Needed**: AMIs simplify the process of setting up instances by providing pre-configured templates, ensuring consistency and saving time.
### 3. Instance Types
- **Description**: Different sizes and power levels of virtual computers.
- **Real-World Example**: Choosing between a lightweight laptop for browsing or a high-performance desktop for gaming.
- **Families**:
 - **General Purpose**: Balanced computers for everyday tasks, like a standard laptop (e.g., t2.micro, m5.large).
 - **Compute Optimized**: Powerful processors for heavy computing, like a gaming PC (e.g., c5.large).
 - **Memory Optimized**: Lots of memory for data-intensive tasks, like a server for a database (e.g., r5.large).
 - **Storage Optimized**: High storage capacity and speed for data-heavy tasks, like a video editing workstation (e.g., i3.large).
 - **Why Needed**: Different applications require different levels of performance. Instance types allow you to choose the right balance of CPU, memory, and storage for your needs.
### 4. Key Pairs
- **Description**: Security credentials to access your virtual computer.
- **Real-World Example**: A key to your apartment. Only people with the key can enter.
- **Usage**:
 - **SSH Access**: Use the key to securely log into your Linux virtual computer.
 - **RDP Access**: Use the key to securely log into your Windows virtual computer.
 - **Why Needed**: Key pairs ensure secure access to your instances, preventing unauthorized users from logging in.
### 5. Elastic Block Store (EBS)
- **Description**: Extra storage for your virtual computer.
- **Real-World Example**: An external hard drive that you can attach to your computer for more storage.
- **Types**:
 - **General Purpose SSD (gp2/gp3)**: Standard storage for everyday use, like a regular USB drive.
 - **Provisioned IOPS SSD (io1/io2)**: High-speed storage for fast access, like a high-performance SSD.
 - **Throughput Optimized HDD (st1)**: Low-cost storage for large files, like an external hard drive for backups.
 - **Cold HDD (sc1)**: Cheapest storage for infrequently accessed data, like a large archive box in storage.
 - **Why Needed**: EBS provides persistent storage that retains data even after the instance is stopped, ensuring your data is not lost.
### 6. Elastic IP Address (EIP)
- **Description**: A static IP address for your virtual computer.
- **Real-World Example**: A permanent address for your home, so people can always find you there.
- **Usage**: Useful for virtual computers that need a consistent IP address, like hosting a website.
- **Why Needed**: Instances may get new IP addresses when restarted, making it hard to manage. An Elastic IP provides a consistent IP address that remains the same even if the instance is restarted.
### 7. Security Groups
- **Description**: Rules that control who can access your virtual computer.
- **Real-World Example**: A security guard at the entrance of your building, allowing only certain people in.
- **Usage**: Protect your virtual computers by allowing only necessary traffic, like opening the door only to friends and family.
- **Why Needed**: Security groups protect your instances by controlling inbound and outbound traffic, ensuring that only authorized traffic is allowed.
### 8. Elastic Load Balancing (ELB)
- **Description**: Distributes incoming traffic across multiple virtual computers.
- **Real-World Example**: A receptionist who directs visitors to the correct office based on availability.
- **Types**:
 - **Application Load Balancer (ALB)**: Best for web traffic, like a receptionist for visitors with specific appointments.
 - **Network Load Balancer (NLB)**: Best for high-speed traffic, like a toll booth managing traffic flow on a highway.
 - **Why Needed**: Load balancers ensure that no single instance is overwhelmed with too much traffic, improving availability and reliability of your application.
### 9. Auto Scaling
- **Description**: Automatically adjusts the number of virtual computers based on demand.
- **Real-World Example**: Hiring more staff during busy hours and reducing staff during quiet hours.
- **Key Components**:
 - **Auto Scaling Groups (ASG)**: Groups of virtual computers managed together, like a team of employees.
 - **Launch Configuration/Template**: Pre-defined setup for new virtual computers, like a training manual for new hires.
 - **Scaling Policies**: Rules for when to add or remove virtual computers, like a schedule for increasing or decreasing staff.
 - **Why Needed**: Auto Scaling ensures that you have the right amount of computing power to handle traffic, scaling up during high demand and scaling down to save costs during low demand.
## Putting It All Together
### Example Scenario
1. **Launch an EC2 Instance**: Start a virtual computer using a pre-configured setup (AMI) with your desired size and power (instance type).
2. **Configure Security Groups**: Set up rules to allow necessary traffic, like opening doors for specific people.
3. **Attach EBS Volume**: Add extra storage to your virtual computer for more space.
4. **Assign Elastic IP**: Assign a consistent IP address to your virtual computer for easy access.
5. **Set Up Load Balancer**: Create a system to distribute traffic across multiple virtual computers.
6. **Enable Auto Scaling**: Automatically adjust the number of virtual computers based on traffic demand.
