from brownie import accounts, Ticket, TicketShop
accounts.load("Metamask")

def main():
    token_tix = Ticket.deploy({'from': accounts[0]})
    tixShop = TicketShop.deploy(token_tix, {'from': accounts[0]})