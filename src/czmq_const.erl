-module(czmq_const).
-compile(export_all).

-include_lib("czmq/include/czmq.hrl").

zmq_pair() ->
    ?ZMQ_PAIR.

zmq_pub() ->
    ?ZMQ_PUB.

zmq_sub() ->
    ?ZMQ_SUB.

zmq_req() ->
    ?ZMQ_REQ.

zmq_rep() ->
    ?ZMQ_REP.

zmq_dealer() ->
    ?ZMQ_DEALER.

zmq_router() ->
    ?ZMQ_ROUTER.

zmq_pull() ->
    ?ZMQ_PULL.

zmq_push() ->
    ?ZMQ_PUSH.

zmq_xpub() ->
    ?ZMQ_XPUB.

zmq_xsub() ->
    ?ZMQ_XSUB.

zmq_stream() ->
    ?ZMQ_STREAM.

zframe_more() ->
    ?ZFRAME_MORE.

zframe_reuse() ->
    ?ZFRAME_REUSE.

zframe_dontwait() ->
    ?ZFRAME_DONTWAIT.

curve_allow_any() ->
    ?CURVE_ALLOW_ANY.
