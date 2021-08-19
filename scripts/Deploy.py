from brownie import accounts, Ticket, TicketShop
accounts.load("Metamask")

def main():
    token_tix = Ticket.deploy({'from': accounts[0]},publish_source=True)
    tixShop = TicketShop.deploy(token_tix, {'from': accounts[0]},publish_source=True)