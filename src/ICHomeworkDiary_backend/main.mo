import Time "mo:base/Time";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor HomeworkDiary {

  type Homework = {
    title : Text;
    description : Text;
    dueDate : Time.Time;
    completed : Bool;
  };

  stable var homeworkDiaryList : List.List<(Nat, Homework)> = List.nil();
  var homeworkDiaryMap = HashMap.HashMap<Nat, Homework>(5, Nat.equal, Hash.hash);

  public shared func addHomework(homework : Homework) : async Nat {
    homeworkDiaryMap.put(homeworkDiaryMap.size(), homework);
    return homeworkDiaryMap.size() - 1;
  };

  public query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
    var homework = homeworkDiaryMap.get(id);

    switch (homework) {
      case (?homework) {
        return #ok(homework);
      };
      case (null) {
        return #err("Does not exist!");
      };
    };
  };

  public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
    var oldHomework = homeworkDiaryMap.replace(id, homework);

    switch (oldHomework) {
      case (?oldHomework) {
        return #ok;
      };
      case (null) {
        return #err "Homework does not exist.";
      };
    };
  };

  public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
    var homework = homeworkDiaryMap.get(id);

    switch (homework) {
      case (?homework) {
        let newHomework : Homework = {
          title = homework.title;
          description = homework.description;
          dueDate = homework.dueDate;
          completed = true;
        };
        var old = homeworkDiaryMap.replace(id, newHomework);
        return #ok;
      };
      case (null) {
        return #err "Homework does not exist.";
      };
    };
  };

  public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
    if (id >= homeworkDiaryMap.size()) {
      return #err "Invalid Homework id.";
    } else {
      homeworkDiaryMap.delete(id);
      return #ok;
    };
  };

  public query func getAllHomework() : async [Homework] {
    var allHomeworks = Iter.toArray(homeworkDiaryMap.vals());
    return allHomeworks;
  };
};
