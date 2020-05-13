from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from gateway.config import db
from gateway.db.models import AccountDeposit, GatewayTable, Base, ObjectNotFound, DepositStatus

engine = create_engine(db)
Session = sessionmaker()
Session.configure(bind=engine)
Base.metadata.create_all(engine)
