from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS
from diagrams.aws.database import ElastiCache, RDS
from diagrams.aws.network import Route53
from diagrams.aws.network import TransitGateway
from diagrams.aws.network import VPCPeering
from diagrams.aws.network import VPC
from diagrams.aws.network import NATGateway, InternetGateway
from diagrams.aws.network import PublicSubnet, PrivateSubnet
from diagrams.aws.general import InternetAlt1
from diagrams.aws.network import ElbApplicationLoadBalancer as  ALB





with Diagram("MQ-RQDM-HADR", show=False, direction="BT"):
    


    with Cluster("MQ-RQDM-HADR Cluster"):
        
        with Cluster("VPC A") as vpc_a:
            ig_a = InternetGateway("Internet Gateway A")
            natgw_a = NATGateway("NAT Gateway A")
            alb_a=ALB("MQ A LB")

            with Cluster("MQ-A") as mq_a:
                with Cluster("ZONE A"):
                    mq_a_1 = EC2("dc1-1-mq") 
                
                with Cluster("ZONE B"):
                    mq_a_2 = EC2("dc1-2-mq")

                with Cluster("ZONE C"):
                    mq_a_3 = EC2("dc1-3-mq")

            with Cluster("ZONE D"):
                bastion_a = EC2("dc1-bastion")

            with Cluster("ZONE E"):
                mqipt_a = EC2("dc1-mqipt")

        [mq_a_1,mq_a_2,mq_a_3] >> alb_a >> mqipt_a 

        [mq_a_1,mq_a_2,mq_a_3,mqipt_a]  >> natgw_a
        bastion_a >> ig_a

        with Cluster("VPC B") as vpc_b:
            ig_b = InternetGateway("Internet Gateway B")
            natgw_b = NATGateway("NAT Gateway B")
            alb_b=ALB("MQ A LB")

            with Cluster("MQ-B") as  mq_b:
                with Cluster("ZONE A"):
                    mq_b_1 = EC2("dc2-1-mq") 

                with Cluster("ZONE B"):
                    mq_b_2 = EC2("dc2-2-mq")

                with Cluster("ZONE C"):
                    mq_b_3 = EC2("dc2-3-mq")

            with Cluster("ZONE D"):
                bastion_b = EC2("dc2-bastion")

            with Cluster("ZONE E"):
                mqipt_b = EC2("dc2-mqipt")

            [mq_b_1,mq_b_2,mq_b_3] >> alb_b >> mqipt_b
        
            [mq_b_1,mq_b_2,mq_b_3,mqipt_b]  >> natgw_b
            bastion_b >> ig_b

        with Cluster("External Network") :
        
            alb_g=ALB("MQ Global LB")
            internet=InternetAlt1("Internet") 
            [mqipt_a,mqipt_b] >> alb_g >> internet


        with Cluster("Cross Network") :
            [bastion_a , bastion_b] >>  TransitGateway("Transit Gateway")  >> VPCPeering("VPC Peering")
#        with Cluster("SSH Access Layer") :
#            ssh=InternetAlt1("Internet") 
        
        #[bastion_a,bastion_b] >> internet


