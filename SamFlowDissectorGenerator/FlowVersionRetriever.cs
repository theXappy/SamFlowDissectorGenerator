using System;
using System.Reflection;

namespace SamFlowDissectorGenerator
{
    public class FlowVersionRetriever
    {
        public class FlowVersion
        {
            public int AuthVer { get; set; }
            public int AuthVerMin { get; set; }
            public int NotifVer { get; set; }
            public int NotifVerMin { get; set; }

            public override string ToString()
            {
                return $"{nameof(AuthVer)}: {AuthVer}, " +
                       $"{nameof(AuthVerMin)}: {AuthVerMin}, " +
                       $"{nameof(NotifVer)}: {NotifVer}, " +
                       $"{nameof(NotifVerMin)}: {NotifVerMin}";
            }
        }

        public static FlowVersion GetVersion(Assembly flowAssm)
        {
            // There's a dedicated class to contain the version information
            // in the dll.
            // It's name is 'Sam'sungFlowVersion'
            Type flowVersionType = flowAssm.GetType("Sam"+"sung.Sam"+"sungFlow.Sam" + "sungFlowVersion");
            if (flowVersionType == null) return null;

            FlowVersion fv = new FlowVersion();
            fv.AuthVer = (int)flowVersionType.GetField("AuthenticationProtocolVersion").GetValue(null);
            fv.AuthVerMin =  (int)flowVersionType.GetField("MinimumPhoneNotificationProtocolVersion").GetValue(null);
            fv.NotifVer = (int)flowVersionType.GetField("NotificationProtocolVersion").GetValue(null);
            fv.NotifVerMin = (int)flowVersionType.GetField("MinimumPhoneNotificationProtocolVersion").GetValue(null);
            return fv;
        }
    }
}
