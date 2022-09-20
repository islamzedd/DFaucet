import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter"

actor Token{

    let owner : Principal = Principal.fromText("2dzbx-3im5w-75olv-77ohy-kblm6-afqdz-2sia6-gzqwf-munsm-kpbso-oqe");
    let totalSupply: Nat = 1000000000;
    let token: Text = "SMSM";

    private stable var balanceEntries: [(Principal,Nat)] = [];
    private var balances = HashMap.HashMap<Principal,Nat>(1,Principal.equal,Principal.hash);

    public query func balanceOf(who: Principal): async Nat{
        let balance : Nat = switch (balances.get(who)) {
        case null 0;
        case (?result) result;
        };
        return balance;
    };

    public query func getSymbol():async Text{
        return token;
    };

    public shared(msg) func payOut():async Text{
        if(balances.get(msg.caller) == null){
            let result = await transfer(msg.caller,10000);
            return result;
        }
        else{
            return "Already Claimed"
        }
    };

    public shared(msg) func transfer(to: Principal, amount:Nat):async Text{
        let fromBalance = await balanceOf(msg.caller);
        if(fromBalance > amount){
            let newFromBalance = fromBalance-amount;
            balances.put(msg.caller,newFromBalance);

            let toBalance = await balanceOf(to);
            let newToBalance = toBalance+amount;
            balances.put(to,newToBalance);
            return ("success");
        }
        else{
            return ("Insufficient funds");
        }
    };

    system func preupgrade(){
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade(){
        balances := HashMap.fromIter<Principal,Nat>(balanceEntries.vals(),1,Principal.equal,Principal.hash);
        if(balances.size() < 1 ){
            balances.put(owner,totalSupply);
        }
    };
}