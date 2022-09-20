import React, { useState } from "react";
import {token} from "../../../declarations/token";
import {Principal} from "@dfinity/principal";

function Transfer() {
  const [to,setTo] = useState("");
  const [amount,setAmount] = useState("");
  const [isDisabled,setDisabled]=useState(false);
  const [feedback,setFeedback]= useState("");
  const [isHidden,setHidden]=useState(true); 

  async function handleClick() {
    setDisabled(true);
    setHidden(true);
    const recepient = Principal.fromText(to);
    const amountToTransfer =  Number(amount);
    const result = await token.transfer(recepient,amountToTransfer);
    setFeedback(result);
    setDisabled(false);
    setHidden(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={to}
                onChange={(e)=>setTo(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={amount}
                onChange={(e)=>setAmount(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button disabled={isDisabled} id="btn-transfer" onClick={handleClick} >
            Transfer
          </button>
        </p>
        <p hidden={isHidden}>{feedback}</p>
      </div>
    </div>
  );
}

export default Transfer;
