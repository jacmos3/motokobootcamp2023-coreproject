import Principal "mo:base/Principal";
import Char "mo:base/Char";

actor {
    public shared query (msg) func whoami() : async Principal {
        return msg.caller;
    };
};