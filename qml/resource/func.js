//克隆对象
function objClone(obj){
    var o;
    switch(typeof obj){
    case 'undefined': break;
    case 'string'   : o = obj + '';break;
    case 'number'   : o = obj - 0;break;
    case 'boolean'  : o = obj;break;
    case 'object'   :
        if(obj === null){
            o = null;
        }else{
            if(obj instanceof Array){
                o = [];
                for(var i = 0, len = obj.length; i < len; i++){
                    o.push(objClone(obj[i]));
                }
            }else{
                o = {};
                for(var k in obj){
                    o[k] = objClone(obj[k]);
                }
            }
        }
        break;
    default:
        o = obj;break;
    }
    return o;
}

